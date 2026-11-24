"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
async function main() {
    console.log("🌱 Seeding QuickFix database with real commercial catalog...");
    // 1. Create Default Verified User & Demo Technician
    const demoUser = await prisma.user.upsert({
        where: { phoneNumber: "+919876543210" },
        update: {},
        create: {
            phoneNumber: "+919876543210",
            fullName: "Arjun Verma",
            email: "arjun.verma@quickfix.care",
            role: "CUSTOMER",
            isVerified: true,
            addresses: {
                create: {
                    label: "Home",
                    addressLine1: "#402, Green Glen Layout, Bellandur",
                    addressLine2: "Near Outer Ring Road",
                    city: "Bengaluru",
                    state: "Karnataka",
                    postalCode: "560103",
                    latitude: 12.9279,
                    longitude: 77.6749,
                    isDefault: true,
                },
            },
        },
    });
    const demoTech = await prisma.technician.upsert({
        where: { phoneNumber: "+919988776655" },
        update: {},
        create: {
            fullName: "Rajesh Kannan",
            phoneNumber: "+919988776655",
            rating: 4.96,
            totalJobs: 412,
            vehicleType: "QuickFix Express EV (KA-03-QF-9081)",
            currentLat: 12.9290,
            currentLng: 77.6760,
            isActive: true,
        },
    });
    console.log(`👤 Seeded User: ${demoUser.fullName} & Tech: ${demoTech.fullName}`);
    // 2. Seed Brands
    const brandsData = [
        { name: "Apple", slug: "apple", popularity: 100, country: "USA" },
        { name: "Samsung", slug: "samsung", popularity: 95, country: "South Korea" },
        { name: "OnePlus", slug: "oneplus", popularity: 90, country: "China" },
        { name: "Xiaomi", slug: "xiaomi", popularity: 88, country: "China" },
        { name: "Google Pixel", slug: "pixel", popularity: 85, country: "USA" },
        { name: "Vivo", slug: "vivo", popularity: 75, country: "China" },
        { name: "Oppo", slug: "oppo", popularity: 72, country: "China" },
        { name: "Realme", slug: "realme", popularity: 70, country: "China" },
        { name: "Motorola", slug: "motorola", popularity: 68, country: "USA" },
        { name: "Nothing", slug: "nothing", popularity: 65, country: "UK" },
        { name: "Huawei", slug: "huawei", popularity: 60, country: "China" },
        { name: "Nokia", slug: "nokia", popularity: 55, country: "Finland" },
    ];
    for (const b of brandsData) {
        const brand = await prisma.brand.upsert({
            where: { slug: b.slug },
            update: { popularity: b.popularity },
            create: b,
        });
        // Seed flagship & popular models for each brand
        if (b.slug === "xiaomi") {
            const models = [
                { name: "Xiaomi 14 Ultra", slug: "xiaomi-14-ultra", series: "Xiaomi Flagship", releaseYear: 2024 },
                { name: "Xiaomi 14", slug: "xiaomi-14", series: "Xiaomi Flagship", releaseYear: 2024 },
                { name: "Redmi Note 13 Pro+ 5G", slug: "redmi-note-13-pro-plus", series: "Redmi Note Series", releaseYear: 2024 },
                { name: "Redmi 12 5G / POCO M6 Pro", slug: "redmi-12-5g", series: "Redmi Number Series", releaseYear: 2023 },
                { name: "Xiaomi 13 Pro", slug: "xiaomi-13-pro", series: "Xiaomi Flagship", releaseYear: 2023 },
                { name: "POCO X6 Pro 5G", slug: "poco-x6-pro", series: "POCO X Series", releaseYear: 2024 },
            ];
            for (const m of models) {
                const model = await prisma.deviceModel.upsert({
                    where: { slug: m.slug },
                    update: {},
                    create: {
                        ...m,
                        brandId: brand.id,
                        hasOemParts: true,
                    },
                });
                await seedRepairsForModel(model.id);
            }
        }
        else if (b.slug === "apple") {
            const models = [
                { name: "iPhone 15 Pro Max", slug: "iphone-15-pro-max", series: "Pro Series", releaseYear: 2023 },
                { name: "iPhone 15 Pro", slug: "iphone-15-pro", series: "Pro Series", releaseYear: 2023 },
                { name: "iPhone 15", slug: "iphone-15", series: "Standard Series", releaseYear: 2023 },
                { name: "iPhone 14 Pro Max", slug: "iphone-14-pro-max", series: "Pro Series", releaseYear: 2022 },
                { name: "iPhone 14", slug: "iphone-14", series: "Standard Series", releaseYear: 2022 },
                { name: "iPhone 13", slug: "iphone-13", series: "Standard Series", releaseYear: 2021 },
            ];
            for (const m of models) {
                const model = await prisma.deviceModel.upsert({
                    where: { slug: m.slug },
                    update: {},
                    create: { ...m, brandId: brand.id, hasOemParts: true },
                });
                await seedRepairsForModel(model.id);
            }
        }
        else if (b.slug === "samsung") {
            const models = [
                { name: "Galaxy S24 Ultra", slug: "galaxy-s24-ultra", series: "Galaxy S Series", releaseYear: 2024 },
                { name: "Galaxy S24+", slug: "galaxy-s24-plus", series: "Galaxy S Series", releaseYear: 2024 },
                { name: "Galaxy S24", slug: "galaxy-s24", series: "Galaxy S Series", releaseYear: 2024 },
                { name: "Galaxy Z Fold 5", slug: "galaxy-z-fold-5", series: "Galaxy Z Series", releaseYear: 2023 },
                { name: "Galaxy S23 Ultra", slug: "galaxy-s23-ultra", series: "Galaxy S Series", releaseYear: 2023 },
            ];
            for (const m of models) {
                const model = await prisma.deviceModel.upsert({
                    where: { slug: m.slug },
                    update: {},
                    create: { ...m, brandId: brand.id, hasOemParts: true },
                });
                await seedRepairsForModel(model.id);
            }
        }
        else if (b.slug === "oneplus") {
            const models = [
                { name: "OnePlus 12", slug: "oneplus-12", series: "Number Flagship", releaseYear: 2024 },
                { name: "OnePlus 12R", slug: "oneplus-12r", series: "R Performance", releaseYear: 2024 },
                { name: "OnePlus 11 5G", slug: "oneplus-11", series: "Number Flagship", releaseYear: 2023 },
                { name: "OnePlus Nord 4", slug: "oneplus-nord-4", series: "Nord Series", releaseYear: 2024 },
            ];
            for (const m of models) {
                const model = await prisma.deviceModel.upsert({
                    where: { slug: m.slug },
                    update: {},
                    create: { ...m, brandId: brand.id, hasOemParts: true },
                });
                await seedRepairsForModel(model.id);
            }
        }
        else if (b.slug === "pixel") {
            const models = [
                { name: "Pixel 9 Pro XL", slug: "pixel-9-pro-xl", series: "Pixel 9 Series", releaseYear: 2024 },
                { name: "Pixel 8 Pro", slug: "pixel-8-pro", series: "Pixel 8 Series", releaseYear: 2023 },
                { name: "Pixel 8", slug: "pixel-8", series: "Pixel 8 Series", releaseYear: 2023 },
                { name: "Pixel 7a", slug: "pixel-7a", series: "Pixel A Series", releaseYear: 2023 },
            ];
            for (const m of models) {
                const model = await prisma.deviceModel.upsert({
                    where: { slug: m.slug },
                    update: {},
                    create: { ...m, brandId: brand.id, hasOemParts: true },
                });
                await seedRepairsForModel(model.id);
            }
        }
    }
    console.log("✅ Seed completed successfully!");
}
async function seedRepairsForModel(modelId) {
    const repairs = [
        {
            title: "OEM Original Display & Digitizer Replacement",
            category: "SCREEN",
            description: "Brand-grade 120Hz AMOLED/OLED replacement panel with TrueTone calibration and gorilla glass protection.",
            price: 3899.0,
            turnaroundMinutes: 120,
            warrantyDays: 180,
            badge: "OEM Certified",
            isPopular: true,
        },
        {
            title: "High-Capacity Li-Ion Battery Replacement",
            category: "BATTERY",
            description: "Fresh 0-cycle OEM battery cell with temperature protection sensor and 500+ charge cycles.",
            price: 1899.0,
            turnaroundMinutes: 90,
            warrantyDays: 180,
            badge: "Fast Fix",
            isPopular: true,
        },
        {
            title: "Type-C Fast Charging Port Board",
            category: "CHARGING",
            description: "Sub-board replacement with original fast charging IC and integrated microphone.",
            price: 1299.0,
            turnaroundMinutes: 60,
            warrantyDays: 90,
            badge: null,
            isPopular: false,
        },
        {
            title: "Rear Camera Module & OIS Calibration",
            category: "CAMERA",
            description: "Complete camera module replacement with autofocus and optical image stabilization restore.",
            price: 2499.0,
            turnaroundMinutes: 120,
            warrantyDays: 90,
            badge: null,
            isPopular: false,
        },
        {
            title: "Factory Rear Glass Back Cover",
            category: "BACK_GLASS",
            description: "Precision laser back glass removal and factory seal replacement with camera ring.",
            price: 1499.0,
            turnaroundMinutes: 90,
            warrantyDays: 90,
            badge: null,
            isPopular: false,
        },
        {
            title: "Ultrasonic Water Damage Decontamination",
            category: "WATER_DAMAGE",
            description: "Full motherboard chemical wash, micro-soldering short-circuit detection, and thermal testing.",
            price: 1999.0,
            turnaroundMinutes: 240,
            warrantyDays: 60,
            badge: "Lab Intensive",
            isPopular: false,
        },
    ];
    for (const r of repairs) {
        await prisma.repairService.create({
            data: {
                ...r,
                modelId,
            },
        });
    }
}
main()
    .catch((e) => {
    console.error(e);
    process.exit(1);
})
    .finally(async () => {
    await prisma.$disconnect();
});
