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
