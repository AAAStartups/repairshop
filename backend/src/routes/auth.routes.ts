import { Router, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { prisma } from "../db.js";
import { authenticate, AuthenticatedRequest } from "../middleware/auth.js";

export const authRouter = Router();

// Rate limiter map: phoneNumber -> Array of request timestamps
const otpRequestTimestamps = new Map<string, number[]>();
const MAX_REQUESTS = 5;
const WINDOW_MS = 10 * 60 * 1000; // 10 minutes

const sendOtpSchema = z.object({
  phoneNumber: z.string().min(10, "Phone number must be at least 10 digits"),
});

const verifyOtpSchema = z.object({
  phoneNumber: z.string().min(10),
  otp: z.string().length(6, "OTP must be 6 digits"),
  fullName: z.string().optional(),
});

// POST /api/auth/send-otp
authRouter.post("/send-otp", async (req: Request, res: Response) => {
  try {
    const { phoneNumber } = sendOtpSchema.parse(req.body);

    // Rate-limiting check
    const now = Date.now();
    const timestamps = (otpRequestTimestamps.get(phoneNumber) || []).filter(
      (ts) => now - ts < WINDOW_MS
    );

    if (timestamps.length >= MAX_REQUESTS) {
      const oldest = timestamps[0];
      const waitSeconds = Math.ceil((WINDOW_MS - (now - oldest)) / 1000);
      return res.status(429).json({
        success: false,
        message: `Too many OTP requests. Please try again in ${waitSeconds} seconds.`,
        retryAfterSeconds: waitSeconds,
      });
    }

    timestamps.push(now);
    otpRequestTimestamps.set(phoneNumber, timestamps);

    // In commercial dev mode, OTP is 123456 (or logged to console for test phones)
    console.log(`📲 [SMS GATEWAY SIMULATOR] Sent OTP '123456' to ${phoneNumber}`);

    return res.json({
      success: true,
      message: "OTP sent successfully to " + phoneNumber,
      expiresInSeconds: 300,
    });
  } catch (error: any) {
    return res.status(400).json({ success: false, message: error.errors?.[0]?.message || error.message });
  }
});

// POST /api/auth/verify-otp
authRouter.post("/verify-otp", async (req: Request, res: Response) => {
  try {
    const { phoneNumber, otp, fullName } = verifyOtpSchema.parse(req.body);

    // Verify OTP logic (acceptance for 123456 or dynamic simulation)
    if (otp !== "123456") {
      return res.status(400).json({ success: false, message: "Invalid OTP. Use 123456 in dev mode." });
    }

    // Find or create user
    let user = await prisma.user.findUnique({
      where: { phoneNumber },
      include: { addresses: true },
    });

    if (!user) {
      user = await prisma.user.create({
        data: {
          phoneNumber,
          fullName: fullName || "QuickFix Member",
          isVerified: true,
        },
        include: { addresses: true },
      });
    } else if (fullName && (!user.fullName || user.fullName === "QuickFix Member")) {
      user = await prisma.user.update({
        where: { id: user.id },
        data: { fullName },
        include: { addresses: true },
      });
    }

    const JWT_SECRET = process.env.JWT_SECRET || "quickfix_super_secure_jwt_secret_dev_2026_key";
    const token = jwt.sign(
      { userId: user.id, phoneNumber: user.phoneNumber, role: user.role },
      JWT_SECRET,
      { expiresIn: "30d" }
    );

    return res.json({
      success: true,
      token,
      user: {
        id: user.id,
        phoneNumber: user.phoneNumber,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
        addresses: user.addresses,
      },
    });
  } catch (error: any) {
    return res.status(400).json({ success: false, message: error.errors?.[0]?.message || error.message });
  }
});

// GET /api/auth/me
authRouter.get("/me", authenticate, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user!.userId },
      include: {
        addresses: true,
        bookings: {
          orderBy: { createdAt: "desc" },
          take: 5,
          include: {
            deviceModel: { include: { brand: true } },
            repairItems: { include: { repairService: true } },
          },
        },
      },
    });

    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    return res.json({ success: true, user });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});
