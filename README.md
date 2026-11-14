# QuickFix (RepairShop) 📱⚡

A modern, consumer-grade mobile application for on-demand electronics and smartphone repair services, inspired by CRED, Urban Company, and Zepto.

Built with **Flutter** (Dart), **Riverpod**, and **GoRouter**, adhering to strict UX standards with responsive design, 60/120fps animations, haptic micro-interactions, and zero-advance doorstep booking.

---

## 🌟 Highlights

- **Guest-First Exploration:** Browse 8+ device categories, hundreds of smartphone/laptop models, transparent repair cost breakdowns, and available pickup slots with zero mandatory login.
- **Doorstep Convenience:** Schedule pickup date and hourly slots with automatic GPS address detection.
- **Zero Advance Payment:** Pay only after inspection and verification upon doorstep delivery (Cash or UPI).
- **12-Stage Visual Live Tracker:** Phased live radar status tracking your device from pickup, lab cleanroom diagnostics, OEM part fitting, to final quality assurance and delivery.
- **Tactile UI/UX System:**
  - Ambient shimmer sweeps across hero elements.
  - Phased concentric ripple radar rings (`QFAnimatedPulse`).
  - Haptic spring bounce on all pressable cards and buttons (`QFPressable`).
  - Deep Forest Green (`#003A26`) and Golden Amber (`#EDB000`) color palette.

---

## 🛠️ Architecture & Tech Stack

- **Framework:** Flutter 3.x (Impeller Vulkan backend)
- **State Management:** Riverpod 2.6 (`flutter_riverpod`)
- **Navigation:** Declarative routing with `go_router` (Stateful Shell navigation)
- **Design System:** Custom token-based design system (`lib/core/`)
- **Architecture:** Feature-first Clean Architecture (`core`, `features/{auth, booking, catalog, home, orders, profile, splash, support, tracking}`)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24+ or newer
- Android Studio / Xcode
- Physical device or Emulator

### Installation & Run
```bash
# Clone the repository
git clone https://github.com/AAAStartups/repairshop.git
cd repairshop

# Fetch dependencies
flutter pub get

# Run test suite
flutter test

# Run on connected device
flutter run
```

---

## 🧪 Tests
Run automated widget and domain tests:
```bash
flutter test
```
- Brand catalog verification
- Repair pricing & category checks
- Booking draft state preservation
- Animated button & pulse indicator widget tests

---

## 📄 License
Private repository © 2026 AAAStartups. All rights reserved.
