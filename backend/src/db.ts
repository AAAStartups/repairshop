import { PrismaClient } from "@prisma/client";
import fs from "fs";
import path from "path";

if (process.env.VERCEL) {
  try {
    const tmpDb = path.join("/tmp", "dev.db");
    const sourceDb = path.join(process.cwd(), "prisma", "dev.db");
    if (!fs.existsSync(tmpDb) && fs.existsSync(sourceDb)) {
      fs.copyFileSync(sourceDb, tmpDb);
      console.log("Copied SQLite database to /tmp/dev.db for writable serverless execution");
    }
    process.env.DATABASE_URL = `file:${tmpDb}`;
  } catch (err) {
    console.warn("Warning: could not copy dev.db to /tmp:", err);
  }
}

const globalForPrisma = global as unknown as { prisma: PrismaClient };

export const prisma =
  globalForPrisma.prisma ||
  new PrismaClient({
    log: process.env.NODE_ENV === "development" ? ["query", "error", "warn"] : ["error"],
  });

if (process.env.NODE_ENV !== "production") globalForPrisma.prisma = prisma;
