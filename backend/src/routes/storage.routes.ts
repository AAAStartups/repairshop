import { Router, Request, Response } from "express";
import { z } from "zod";

export const storageRouter = Router();

const SUPABASE_URL = process.env.SUPABASE_URL || "https://alenvqljzoobubcpsuxa.supabase.co";
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || "";
const BUCKET_NAME = "device-photos";

const uploadSchema = z.object({
  fileName: z.string().optional(),
  fileData: z.string().min(1, "fileData (base64) is required"),
  contentType: z.string().default("image/jpeg"),
});

// POST /api/storage/upload - Upload diagnostic image to Supabase Cloud Storage
storageRouter.post("/upload", async (req: Request, res: Response) => {
  try {
    const { fileName, fileData, contentType } = uploadSchema.parse(req.body);

    // Clean base64 string
    const base64Data = fileData.replace(/^data:image\/\w+;base64,/, "");
    const buffer = Buffer.from(base64Data, "base64");

    const ext = contentType.includes("png") ? "png" : "jpg";
    const uniqueName = fileName || `device_${Date.now()}_${Math.random().toString(36).substring(2, 8)}.${ext}`;

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
