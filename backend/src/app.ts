import express, { Application, Request, Response } from "express";
import cors from "cors";
import { authRouter } from "./routes/auth.routes.js";
import { catalogRouter } from "./routes/catalog.routes.js";
import { bookingRouter } from "./routes/booking.routes.js";
import { orderRouter } from "./routes/order.routes.js";

export const app: Application = express();

// Middlewares
app.use(cors({ origin: "*" }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health Check
app.get("/api/health", (_req: Request, res: Response) => {
  res.json({
    status: "healthy",
    service: "QuickFix Core API Engine",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
  });
});

// Routes
app.use("/api/auth", authRouter);
app.use("/api/catalog", catalogRouter);
app.use("/api/bookings", bookingRouter);
app.use("/api/orders", orderRouter);

// 404 Handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({ success: false, message: "QuickFix API route not found" });
});
