import { Router, Request, Response } from "express";
import { prisma } from "../db.js";
import { authenticate, AuthenticatedRequest } from "../middleware/auth.js";

export const orderRouter = Router();

// In-memory state for interactive demo order simulation
let demoStageIndex = 4;

const demoTimelineStages = [
  { stageIndex: 1, stageCode: "BOOKING_CONFIRMED", title: "Booking Confirmed", description: "Slot reserved with ₹0 advance commitment." },
  { stageIndex: 2, stageCode: "TECH_ASSIGNED", title: "Technician Assigned", description: "Lead Specialist Rajesh Kumar (4.9★, 1,240+ repairs)." },
  { stageIndex: 3, stageCode: "EN_ROUTE", title: "En Route to Doorstep", description: "Specialist is 8 minutes away with ESD mobile kit." },
  { stageIndex: 4, stageCode: "DOORSTEP_INSPECTION", title: "Doorstep Physical Inspection", description: "42-point pre-repair diagnostics performed in front of customer." },
  { stageIndex: 5, stageCode: "SEALED_POUCH", title: "Sealed in Tamper-Proof Pouch", description: "Device secured in Barcode Pouch #TP-84920 with tamper tape." },
  { stageIndex: 6, stageCode: "TRANSIT_TO_HUB", title: "In Transit to Cleanroom Hub", description: "Secure transport with temperature-controlled transit box." },
  { stageIndex: 7, stageCode: "HUB_CHECKIN", title: "Cleanroom Check-in & ESD Sanitization", description: "Class-100 Cleanroom inspection and ionizer dust blow." },
  { stageIndex: 8, stageCode: "DIAGNOSTIC_SCAN", title: "42-Point Automated Diagnostic Scan", description: "Motherboard micro-current and display digitizer scan passed." },
  { stageIndex: 9, stageCode: "PRECISION_REPAIR", title: "Precision OEM Component Installation", description: "Original OEM display panel installed with TrueTone calibration." },
  { stageIndex: 10, stageCode: "QUALITY_TESTING", title: "18-Step Automated Quality Testing", description: "30-minute thermal burn-in, touch response, and audio verification." },
  { stageIndex: 11, stageCode: "RETURN_DELIVERY", title: "Out for Return Delivery", description: "Technician en route to return device to customer's doorstep." },
  { stageIndex: 12, stageCode: "COMPLETED", title: "Doorstep Handover & Warranty Issued", description: "Device tested with customer. 180-Day Diamond Warranty active." },
];

function getDemoOrderResponse(stageIdx: number) {
  const currentStage = demoTimelineStages[stageIdx - 1] || demoTimelineStages[0];
  return {
    success: true,
    order: {
      id: "demo-qf-89421",
      bookingNumber: "QF-89421",
      device: "Apple iPhone 15 Pro Max",
      totalAmount: 3899,
      advancePaid: 0,
      paymentStatus: stageIdx >= 12 ? "PAID" : "ZERO_ADVANCE_POSTPAID",
      status: currentStage.stageCode,
      address: "Flat 402, Embassy Habitat, 100 Feet Rd, Indiranagar, Bengaluru",
      technician: {
        id: "tech-rajesh-01",
        name: "Rajesh Kumar",
        phone: "+91 98450 12345",
        rating: 4.9,
        vehicle: "Electric Van (Kit #14)",
      },
      currentStageIndex: currentStage.stageIndex,
      currentStageCode: currentStage.stageCode,
      timeline: demoTimelineStages.map((t) => ({
        stageIndex: t.stageIndex,
        stageCode: t.stageCode,
        title: t.title,
        description: t.description,
        isCompleted: t.stageIndex < currentStage.stageIndex,
        isCurrent: t.stageIndex === currentStage.stageIndex,
        timestamp: new Date(Date.now() - (currentStage.stageIndex - t.stageIndex) * 3600000).toISOString(),
      })),
      warrantyCertificate: {
        durationDays: 180,
        title: "180-Day QuickFix Diamond Warranty",
        coverage: "All replaced OEM panels, batteries, and charging boards.",
        warrantyId: "WAR-2026-89421",
        validUntil: new Date(Date.now() + 180 * 86400000).toISOString(),
      },
    },
    currentStage: {
      stageIndex: currentStage.stageIndex,
      stageCode: currentStage.stageCode,
      title: currentStage.title,
      description: currentStage.description,
    },
  };
}

// GET /api/orders/:id/track - Fetch live 12-stage tracking timeline
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
      // Graceful fallback for demo order QF-89421 or any QF- prefix
      if (id.toUpperCase().startsWith("QF-") || id === "demo") {
        return res.json(getDemoOrderResponse(demoStageIndex));
      }
      return res.status(404).json({ success: false, message: "Order not found" });
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

// POST /api/orders/:id/advance-stage (Technician / Dispatch simulation endpoint)
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
      // Demo order progression simulation
      demoStageIndex = (demoStageIndex % 12) + 1;
      const nextStage = demoTimelineStages[demoStageIndex - 1];
      return res.json({
        success: true,
        message: `Advanced to stage ${demoStageIndex}: ${nextStage.title}`,
        newStageIndex: demoStageIndex,
        stageTitle: nextStage.title,
        advancedStage: nextStage,
      });
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
