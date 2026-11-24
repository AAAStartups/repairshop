import { Router, Response } from "express";
import { z } from "zod";
import { prisma } from "../db.js";
import { authenticate, AuthenticatedRequest } from "../middleware/auth.js";

export const bookingRouter = Router();

const createBookingSchema = z.object({
  deviceModelId: z.string().min(1, "Device model is required"),
  repairServiceIds: z.array(z.string()).min(1, "At least one repair service must be selected"),
  problemNotes: z.string().optional(),
  deviceImages: z.array(z.string()).optional(),
  scheduledDate: z.string().min(1, "Scheduled date is required"),
  timeSlot: z.string().min(1, "Time slot is required"),
  address: z.object({
    label: z.string().default("Home"),
    addressLine1: z.string().min(3, "Address is required"),
    addressLine2: z.string().optional(),
    city: z.string().default("Bengaluru"),
    state: z.string().default("Karnataka"),
    postalCode: z.string().min(6, "Valid 6-digit postal code required"),
    latitude: z.number().optional(),
    longitude: z.number().optional(),
  }),
});

// POST /api/bookings - Create new guest or authenticated booking
bookingRouter.post("/", authenticate, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const data = createBookingSchema.parse(req.body);
    const userId = req.user!.userId;

    // Verify device
    const device = await prisma.deviceModel.findUnique({
      where: { id: data.deviceModelId },
      include: { brand: true },
    });
    if (!device) {
      return res.status(404).json({ success: false, message: "Device model not found" });
    }

    // Verify repairs
    const repairs = await prisma.repairService.findMany({
      where: {
        id: { in: data.repairServiceIds },
        modelId: device.id,
      },
    });
    if (repairs.length === 0) {
      return res.status(400).json({ success: false, message: "No valid repair services found" });
    }

    const totalAmount = repairs.reduce((acc, curr) => acc + curr.price, 0);

    // Save Address
    const address = await prisma.address.create({
      data: {
        userId,
        label: data.address.label,
        addressLine1: data.address.addressLine1,
        addressLine2: data.address.addressLine2,
        city: data.address.city,
        state: data.address.state,
        postalCode: data.address.postalCode,
        latitude: data.address.latitude,
        longitude: data.address.longitude,
      },
    });

    // Auto-assign top active technician nearby
    const technician = await prisma.technician.findFirst({
      where: { isActive: true },
      orderBy: { rating: "desc" },
    });

    // Unique Booking Number (e.g. QF-2026-8921)
    const randomSuffix = Math.floor(1000 + Math.random() * 9000);
    const bookingNumber = `QF-2026-${randomSuffix}`;

    const booking = await prisma.booking.create({
      data: {
        bookingNumber,
        userId,
        deviceModelId: device.id,
        addressId: address.id,
        scheduledDate: new Date(data.scheduledDate),
        timeSlot: data.timeSlot,
        problemNotes: data.problemNotes,
        deviceImagesJson: data.deviceImages ? JSON.stringify(data.deviceImages) : null,
        totalAmount,
        advancePaid: 0.0, // QuickFix Zero Advance Policy
        status: "BOOKING_CONFIRMED",
        paymentStatus: "PENDING",
        assignedTechId: technician?.id || null,
        repairItems: {
          create: repairs.map((r) => ({
            repairServiceId: r.id,
            priceAtBooking: r.price,
            warrantyDays: r.warrantyDays,
          })),
        },
      },
      include: {
        deviceModel: { include: { brand: true } },
        address: true,
        assignedTech: true,
        repairItems: { include: { repairService: true } },
      },
    });

    // Seed the 12 lifecycle stages for real-time tracking
    const stages = [
      { index: 1, code: "BOOKING_CONFIRMED", title: "Booking Confirmed", desc: "Your doorstep pickup order has been scheduled.", completed: true, current: false },
      { index: 2, code: "TECH_ASSIGNED", title: "Technician Assigned", desc: `${technician?.fullName || "Certified Technician"} has been assigned to your service ticket.`, completed: true, current: true },
      { index: 3, code: "EN_ROUTE_TO_PICKUP", title: "En Route for Pickup", desc: "Technician is on the way to your doorstep with ESD toolkits.", completed: false, current: false },
      { index: 4, code: "PICKUP_INSPECTION", title: "Doorstep 42-Point Inspection", desc: "Initial hardware health checklist and photographic documentation.", completed: false, current: false },
      { index: 5, code: "DEVICE_SEALED", title: "Device Sealed in Pouch", desc: "Tamper-proof security barcode bag sealed in your presence.", completed: false, current: false },
      { index: 6, code: "IN_TRANSIT_TO_LAB", title: "In Transit to Cleanroom Lab", desc: "Secure transport with GPS monitoring to our central facility.", completed: false, current: false },
      { index: 7, code: "LAB_DIAGNOSTICS", title: "Class-100 Cleanroom Diagnostics", desc: "Thermal camera & micro-soldering short-circuit analysis.", completed: false, current: false },
      { index: 8, code: "REPAIR_IN_PROGRESS", title: "OEM Parts Replacement", desc: "Precision factory adhesive curing and component install.", completed: false, current: false },
      { index: 9, code: "QC_TESTING", title: "Quality Assurance Calibration", desc: "Display colorimeter, battery cycle and waterproofing test.", completed: false, current: false },
      { index: 10, code: "DISPATCHED_FOR_RETURN", title: "Dispatched for Return", desc: "Repaired device packaged and assigned to courier.", completed: false, current: false },
      { index: 11, code: "DELIVERED_AND_VERIFIED", title: "Doorstep Return & Demo", desc: "Customer testing and satisfaction verification.", completed: false, current: false },
      { index: 12, code: "PAYMENT_COMPLETED", title: "Post-Service Payment & Warranty", desc: "Zero advance payment fulfilled. 180-Day Guarantee issued.", completed: false, current: false },
    ];

    for (const s of stages) {
      await prisma.orderTimelineEvent.create({
        data: {
          bookingId: booking.id,
          stageIndex: s.index,
          stageCode: s.code,
          title: s.title,
          description: s.desc,
          isCompleted: s.completed,
          isCurrent: s.current,
        },
      });
    }

    return res.status(201).json({
      success: true,
      message: "Booking created successfully",
      booking: {
        id: booking.id,
        bookingNumber: booking.bookingNumber,
        device: `${booking.deviceModel.brand.name} ${booking.deviceModel.name}`,
        totalAmount: booking.totalAmount,
        advancePaid: booking.advancePaid,
        status: booking.status,
        scheduledDate: booking.scheduledDate,
        timeSlot: booking.timeSlot,
        address: `${booking.address.addressLine1}, ${booking.address.city} - ${booking.address.postalCode}`,
        technician: booking.assignedTech
          ? {
              name: booking.assignedTech.fullName,
              phone: booking.assignedTech.phoneNumber,
              rating: booking.assignedTech.rating,
              vehicle: booking.assignedTech.vehicleType,
            }
          : null,
      },
    });
  } catch (error: any) {
    return res.status(400).json({ success: false, message: error.errors?.[0]?.message || error.message });
  }
});

// GET /api/bookings - List all bookings of authenticated user
bookingRouter.get("/", authenticate, async (req: AuthenticatedRequest, res: Response) => {
  try {
    const userId = req.user!.userId;
    const bookings = await prisma.booking.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      include: {
        deviceModel: { include: { brand: true } },
        address: true,
        assignedTech: true,
        repairItems: { include: { repairService: true } },
        timelineEvents: { orderBy: { stageIndex: "asc" } },
      },
    });

    return res.json({
      success: true,
      count: bookings.length,
      bookings: bookings.map((b) => ({
        id: b.id,
        bookingNumber: b.bookingNumber,
        brand: b.deviceModel.brand.name,
        deviceModel: b.deviceModel.name,
        status: b.status,
        scheduledDate: b.scheduledDate,
        timeSlot: b.timeSlot,
        totalAmount: b.totalAmount,
        advancePaid: b.advancePaid,
        paymentStatus: b.paymentStatus,
        services: b.repairItems.map((r) => r.repairService.title),
        currentStage: b.timelineEvents.find((e) => e.isCurrent)?.title || "In Progress",
        technician: b.assignedTech ? { name: b.assignedTech.fullName, rating: b.assignedTech.rating } : null,
      })),
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});
