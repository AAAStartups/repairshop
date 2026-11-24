# QuickFix — Commercial Production Deployment Manual

This guide outlines end-to-end production deployment steps for the **QuickFix** ecosystem across the Cloud Backend, Database, Android Play Store, and Apple App Store.

---

## 1. Backend & Database Deployment

### A. Environment Configuration (`./backend/.env.production`)
```env
PORT=8080
NODE_ENV=production
DATABASE_URL="postgresql://quickfix_admin:SECURE_PASSWORD@quickfix-db.rds.amazonaws.com:5432/quickfix_prod?schema=public"
JWT_SECRET="YOUR_LONG_256_BIT_PRODUCTION_SECRET"
FRONTEND_ORIGIN="https://quickfix.care"
TWILIO_ACCOUNT_SID="AC_PRODUCTION_SID"
TWILIO_AUTH_TOKEN="PRODUCTION_TOKEN"
TWILIO_PHONE_NUMBER="+1XXXXXXXXXX"
```

### B. Docker Containerization (`./backend/Dockerfile`)
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY prisma ./prisma/
RUN npm ci
COPY . .
RUN npx prisma generate && npm run build

FROM node:20-alpine AS runner
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/public ./public
RUN npm ci --only=production && npx prisma generate
EXPOSE 8080
CMD ["node", "dist/server.js"]
```

### C. Deploy to Google Cloud Run / AWS ECS
```bash
# 1. Build & Push Image
docker build -t gcr.io/quickfix-prod/quickfix-api:latest ./backend
docker push gcr.io/quickfix-prod/quickfix-api:latest

# 2. Run Database Migrations
cd backend
DATABASE_URL="postgresql://..." npx prisma migrate deploy

# 3. Seed Production Catalog
DATABASE_URL="postgresql://..." npm run prisma:seed
```

---

## 2. Android Google Play Store Release

### A. Generate Upload Keystore
```bash
keytool -genkey -v -keystore android/upload-keystore.jks \
  -alias quickfix-key -keyalg RSA -keysize 2048 -validity 10000
```

### B. Configure `android/key.properties`
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=quickfix-key
storeFile=../upload-keystore.jks
```

### C. Build Signed Android App Bundle
```bash
flutter build appbundle --release --obfuscate --split-debug-info=./build/app/outputs/symbols
```
The resulting `.aab` file at `build/app/outputs/bundle/release/app-release.aab` is ready for upload to Google Play Console (Internal Testing Track).

---

## 3. Operations & Field Dispatch Portals

- **Admin Web Dashboard**: Access `https://api.quickfix.care/admin` for real-time dispatch, fleet telemetry, and revenue monitoring.
- **Technician Companion App**: Accessible within the mobile client under `/technician` or via dedicated technician role authentication.
- **Automated CI/CD**: Every push to `main` executes `.github/workflows/ci.yml` verifying tests, code analysis, and production build readiness.
