import { Router, Request, Response } from "express";
import { prisma } from "../db.js";
import { authenticate, AuthenticatedRequest } from "../middleware/auth.js";

export const orderRouter = Router();

// GET /api/orders/:id/track - Fetch live 12-stage tracking timeline from database
orderRouter.get("/:id/track", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const booking = await prisma.booking.findFirst({
      where: {
        OR: [{ id }, { bookingNumber: id.toUpperCase() }],
      },
      include: {
        deviceModel: { include: { brand: true } },
        address: true,
        assignedTech: true,
        repairItems: { include: { repairService: true } },
        timelineEvents: { orderBy: { stageIndex: "asc" } },
      },
    });

    if (!booking) {
      return res.status(404).json({ success: false, message: "Order not found in database" });
    }

    const currentStage = booking.timelineEvents.find((t) => t.isCurrent) || booking.timelineEvents[0];

    return res.json({
      success: true,
      order: {
        id: booking.id,
        bookingNumber: booking.bookingNumber,
        device: `${booking.deviceModel.brand.name} ${booking.deviceModel.name}`,
        totalAmount: booking.totalAmount,
        advancePaid: booking.advancePaid,
        paymentStatus: booking.paymentStatus,
        status: booking.status,
        address: `${booking.address.addressLine1}, ${booking.address.city}`,
        technician: booking.assignedTech
          ? {
              id: booking.assignedTech.id,
              name: booking.assignedTech.fullName,
              phone: booking.assignedTech.phoneNumber,
              rating: booking.assignedTech.rating,
              vehicle: booking.assignedTech.vehicleType,
            }
          : null,
        currentStageIndex: currentStage?.stageIndex || 1,
        currentStageCode: currentStage?.stageCode || "BOOKING_CONFIRMED",
        timeline: booking.timelineEvents.map((t) => ({
          stageIndex: t.stageIndex,
          stageCode: t.stageCode,
          title: t.title,
          description: t.description,
          isCompleted: t.isCompleted,
          isCurrent: t.isCurrent,
          timestamp: t.timestamp,
        })),
        warrantyCertificate: {
          durationDays: 180,
          title: "180-Day QuickFix Diamond Warranty",
          coverage: "All replaced OEM panels, batteries, and charging boards.",
        },
      },
      currentStage: {
        stageIndex: currentStage?.stageIndex || 1,
        stageCode: currentStage?.stageCode || "BOOKING_CONFIRMED",
        title: currentStage?.title || "Booking Confirmed",
        description: currentStage?.description || "Slot reserved.",
      },
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});

// POST /api/orders/:id/advance-stage (Technician / Dispatch milestone progression)
orderRouter.post("/:id/advance-stage", async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const booking = await prisma.booking.findFirst({
      where: {
        OR: [{ id }, { bookingNumber: id.toUpperCase() }],
      },
      include: {
        timelineEvents: { orderBy: { stageIndex: "asc" } },
      },
    });

    if (!booking) {
      return res.status(404).json({ success: false, message: "Order not found in database" });
    }

    const currentEvent = booking.timelineEvents.find((e) => e.isCurrent);
    if (!currentEvent || currentEvent.stageIndex >= 12) {
      return res.json({ success: true, message: "Order is already at final completed stage", stageIndex: 12 });
    }

    const nextIndex = currentEvent.stageIndex + 1;
    const nextEvent = booking.timelineEvents.find((e) => e.stageIndex === nextIndex);

    // Update current to completed
    await prisma.orderTimelineEvent.update({
      where: { id: currentEvent.id },
      data: { isCompleted: true, isCurrent: false },
    });

    if (nextEvent) {
      await prisma.orderTimelineEvent.update({
        where: { id: nextEvent.id },
        data: { isCompleted: false, isCurrent: true },
      });

      await prisma.booking.update({
        where: { id: booking.id },
        data: { status: nextEvent.stageCode },
      });
    }

    return res.json({
      success: true,
      message: `Advanced to stage ${nextIndex}: ${nextEvent?.title}`,
      newStageIndex: nextIndex,
      stageTitle: nextEvent?.title,
      advancedStage: nextEvent,
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});
