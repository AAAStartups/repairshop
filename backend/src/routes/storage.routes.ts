import { Router, Request, Response } from "express";
import { z } from "zod";
import { v2 as cloudinary } from "cloudinary";

export const storageRouter = Router();

// Configure Cloudinary if credentials are present
if (process.env.CLOUDINARY_URL) {
  cloudinary.config({
    cloudinary_url: process.env.CLOUDINARY_URL,
    secure: true,
  });
} else if (process.env.CLOUDINARY_CLOUD_NAME && process.env.CLOUDINARY_API_KEY) {
  cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
    secure: true,
  });
}

const SUPABASE_URL = process.env.SUPABASE_URL || "https://alenvqljzoobubcpsuxa.supabase.co";
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || "";
const BUCKET_NAME = "device-photos";

const uploadSchema = z.object({
  fileName: z.string().optional(),
  fileData: z.string().min(1, "fileData (base64) is required"),
  contentType: z.string().default("image/jpeg"),
});

// POST /api/storage/upload - Upload diagnostic image to Cloudinary (with fallback)
storageRouter.post("/upload", async (req: Request, res: Response) => {
  try {
    const { fileName, fileData, contentType } = uploadSchema.parse(req.body);

    const base64Data = fileData.replace(/^data:image\/\w+;base64,/, "");
    const ext = contentType.includes("png") ? "png" : "jpg";
    const uniqueName = fileName || `device_${Date.now()}_${Math.random().toString(36).substring(2, 8)}.${ext}`;

    // 1. Primary: Cloudinary Storage
    const hasCloudinary = Boolean(
      process.env.CLOUDINARY_URL || (process.env.CLOUDINARY_CLOUD_NAME && process.env.CLOUDINARY_API_KEY)
    );

    if (hasCloudinary) {
      const dataUri = `data:${contentType};base64,${base64Data}`;
      const uploadResult = await cloudinary.uploader.upload(dataUri, {
        folder: "quickfix_devices",
        public_id: uniqueName.replace(/\.[^/.]+$/, ""),
        resource_type: "image",
      });

      return res.json({
        success: true,
        provider: "cloudinary",
        message: "Photo uploaded to Cloudinary successfully",
        fileName: uniqueName,
        url: uploadResult.secure_url,
        publicId: uploadResult.public_id,
      });
    }

    // 2. Secondary fallback: Supabase Storage
    const buffer = Buffer.from(base64Data, "base64");
    const uploadUrl = `${SUPABASE_URL}/storage/v1/object/${BUCKET_NAME}/${uniqueName}`;

    const response = await fetch(uploadUrl, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
        apikey: SUPABASE_SERVICE_ROLE_KEY,
        "Content-Type": contentType,
      },
      body: buffer,
    });

    if (!response.ok) {
      const errText = await response.text();
      return res.status(response.status).json({
        success: false,
        message: `Failed to upload to cloud storage: ${errText}`,
      });
    }

    const publicUrl = `${SUPABASE_URL}/storage/v1/object/public/${BUCKET_NAME}/${uniqueName}`;

    return res.json({
      success: true,
      provider: "supabase",
      message: "Photo uploaded to cloud storage successfully",
      fileName: uniqueName,
      url: publicUrl,
    });
  } catch (error: any) {
    return res.status(400).json({
      success: false,
      message: error.errors?.[0]?.message || error.message,
    });
  }
});
