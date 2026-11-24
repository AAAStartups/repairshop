import { Router, Request, Response } from "express";
import { prisma } from "../db.js";

export const catalogRouter = Router();

// GET /api/catalog/brands
catalogRouter.get("/brands", async (_req: Request, res: Response) => {
  try {
    const brands = await prisma.brand.findMany({
      where: { isActive: true },
      orderBy: { popularity: "desc" },
      include: {
        _count: {
          select: { models: true },
        },
      },
    });

    return res.json({
      success: true,
      count: brands.length,
      brands: brands.map((b) => ({
        id: b.id,
        name: b.name,
        slug: b.slug,
        logoUrl: b.logoUrl,
        country: b.country,
        modelCount: b._count.models,
        popularity: b.popularity,
      })),
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});

// GET /api/catalog/repairs/popular - Live popular repairs across distinct categories
catalogRouter.get("/repairs/popular", async (_req: Request, res: Response) => {
  try {
    const allRepairs = await prisma.repairService.findMany({
      where: { isActive: true },
      orderBy: [{ price: "asc" }],
      include: {
        model: {
          include: { brand: true },
        },
      },
    });

    const categoryMap = new Map<string, typeof allRepairs[0]>();
    for (const r of allRepairs) {
      const cat = (r.category || "").toUpperCase();
      if (!categoryMap.has(cat)) {
        categoryMap.set(cat, r);
      }
    }

    const categoryOrder = [
      "SCREEN",
      "BATTERY",
      "CHARGING",
      "WATER_DAMAGE",
      "CAMERA",
      "BACK_GLASS",
      "MOTHERBOARD",
      "DIAGNOSTICS",
    ];

    const categoryTemplates: Record<string, { title: string; desc: string; badge: string; defaultPrice: number; discount: string }> = {
      SCREEN: {
        title: "Screen Replacement",
        desc: "Original OEM grade glass & 120Hz display with TrueTone calibration",
        badge: "OEM Grade",
        defaultPrice: 1499,
        discount: "50% OFF",
      },
      BATTERY: {
        title: "Battery Replacement",
        desc: "Restore 100% health & backup with fresh 0-cycle OEM cell",
        badge: "Original Part",
        defaultPrice: 999,
        discount: "50% OFF",
      },
      CHARGING: {
        title: "Charging Port Fix",
        desc: "Type-C & Lightning pin fix, sub-board restore & rapid charge",
        badge: "OEM Grade",
        defaultPrice: 699,
        discount: "46% OFF",
      },
      WATER_DAMAGE: {
        title: "Water Damage Repair",
        desc: "Deep ultrasonic diagnostics, chemical wash & short-circuit fix",
        badge: "Express 60m",
        defaultPrice: 799,
        discount: "46% OFF",
      },
      CAMERA: {
        title: "Camera & Lens Repair",
        desc: "Rear camera module replacement with optical image stabilization",
        badge: "Original Lens",
        defaultPrice: 1299,
        discount: "45% OFF",
      },
      BACK_GLASS: {
        title: "Back Glass Replacement",
        desc: "Precision laser back panel restoration and factory seal",
        badge: "Laser Precision",
        defaultPrice: 899,
        discount: "50% OFF",
      },
      MOTHERBOARD: {
        title: "Motherboard & IC Fix",
        desc: "Micro-soldering, audio IC, power circuit & short detection",
        badge: "Expert Lab",
        defaultPrice: 2499,
        discount: "35% OFF",
      },
      DIAGNOSTICS: {
        title: "Complete Device Diagnostic",
        desc: "Comprehensive 32-point hardware, sensor, and battery health audit",
        badge: "Free Diagnostic",
        defaultPrice: 0,
        discount: "100% FREE",
      },
    };

    const repairs: any[] = [];
    for (const cat of categoryOrder) {
      const r = categoryMap.get(cat);
      const template = categoryTemplates[cat];
      if (r) {
        repairs.push({
          id: r.id,
          title: template ? template.title : r.title,
          category: r.category,
          description: template ? template.desc : r.description,
          price: r.price,
          mrp: r.price > 0 ? Math.round(r.price * 1.8) : null,
          discount: template ? template.discount : "45% OFF",
          turnaroundMinutes: r.turnaroundMinutes,
          warrantyDays: r.warrantyDays,
          badge: template ? template.badge : (r.badge || "OEM Grade"),
          isPopular: true,
          device: `${r.model.brand.name} ${r.model.name}`,
        });
      } else if (template) {
        repairs.push({
          id: `template-${cat.toLowerCase()}`,
          title: template.title,
          category: cat,
          description: template.desc,
          price: template.defaultPrice,
          mrp: template.defaultPrice > 0 ? Math.round(template.defaultPrice * 1.8) : null,
          discount: template.discount,
          turnaroundMinutes: 120,
          warrantyDays: 180,
          badge: template.badge,
          isPopular: true,
          device: "All Smartphones",
        });
      }
    }

    return res.json({
      success: true,
      repairs,
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});

// GET /api/catalog/brands/:brandId/models
catalogRouter.get("/brands/:brandId/models", async (req: Request, res: Response) => {
  try {
    const { brandId } = req.params;
    const { series } = req.query;

    const brand = await prisma.brand.findFirst({
      where: {
        OR: [{ id: brandId }, { slug: brandId.toLowerCase() }],
      },
    });

    if (!brand) {
      return res.status(404).json({ success: false, message: "Brand not found" });
    }

    const whereClause: any = {
      brandId: brand.id,
      isActive: true,
    };

    if (series && series !== "All") {
      whereClause.series = series as string;
    }

    const models = await prisma.deviceModel.findMany({
      where: whereClause,
      orderBy: [{ releaseYear: "desc" }, { name: "asc" }],
      include: {
        _count: {
          select: { repairs: true },
        },
      },
    });

    // Extract unique series
    const allSeries = await prisma.deviceModel.findMany({
      where: { brandId: brand.id, isActive: true },
      select: { series: true },
      distinct: ["series"],
    });

    return res.json({
      success: true,
      brand: { id: brand.id, name: brand.name, slug: brand.slug },
      series: ["All", ...allSeries.map((s) => s.series)],
      models: models.map((m) => ({
        id: m.id,
        name: m.name,
        slug: m.slug,
        series: m.series,
        releaseYear: m.releaseYear,
        imageUrl: m.imageUrl,
        hasOemParts: m.hasOemParts,
        repairCount: m._count.repairs,
      })),
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});

// GET /api/catalog/models/:modelId/repairs
catalogRouter.get("/models/:modelId/repairs", async (req: Request, res: Response) => {
  try {
    const { modelId } = req.params;

    const model = await prisma.deviceModel.findFirst({
      where: {
        OR: [{ id: modelId }, { slug: modelId.toLowerCase() }],
      },
      include: { brand: true },
    });

    if (!model) {
      return res.status(404).json({ success: false, message: "Device model not found" });
    }

    const repairs = await prisma.repairService.findMany({
      where: {
        modelId: model.id,
        isActive: true,
      },
      orderBy: [{ isPopular: "desc" }, { price: "asc" }],
    });

    return res.json({
      success: true,
      device: {
        id: model.id,
        name: model.name,
        brand: model.brand.name,
        releaseYear: model.releaseYear,
        hasOemParts: model.hasOemParts,
      },
      repairs: repairs.map((r) => ({
        id: r.id,
        title: r.title,
        category: r.category,
        description: r.description,
        price: r.price,
        turnaroundMinutes: r.turnaroundMinutes,
        warrantyDays: r.warrantyDays,
        badge: r.badge,
        isPopular: r.isPopular,
      })),
    });
  } catch (error: any) {
    return res.status(500).json({ success: false, message: error.message });
  }
});
