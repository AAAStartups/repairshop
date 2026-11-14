# QuickFix — Flutter Application Development Plan & Architecture

## 1. Project Overview
QuickFix is a premium mobile electronics and smartphone repair service application engineered in Flutter (Dart).
Customers can explore repair catalogues, select their exact device model and damages, schedule doorstep pickup/delivery, and track repairs through an end-to-end 12-stage visual timeline.

**Core Business Rule**: Guest-first exploration. Login is strictly deferred until the user confirms their booking. The booking draft is persisted with zero data loss during phone OTP authentication.

---

## 2. Design System & Theme Specifications
The visual theme is derived from your custom brand specification:

| Token | Color Code | Usage |
|---|---|---|
| **Primary** | `#003A26` | Deep Forest Green — AppBars, buttons, active indicators, titles |
| **Accent / CTA** | `#EDB000` | Golden Yellow — Booking CTAs, badges, banners, key highlights |
| **Dark Surface** | `#1F2D27` | Dark mode surface, card backgrounds, bottom sheets |
| **Muted** | `#5F6F67` | Slate sage — Subtitles, inactive tabs, borders, icons |
| **Background** | `#E8ECEA` | Soft cool background, search input fills, card borders |
| **Typography** | Inter | Modern sans-serif hierarchy across all screen layouts |

---

## 3. Implemented File Inventory & Architecture

```
lib/
├── main.dart                                               # Entry point, ProviderScope, Orientation lock
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                                 # #003A26, #EDB000, #1F2D27, #5F6F67, #E8ECEA
│   │   ├── app_typography.dart                             # Inter font text styles
│   │   └── app_spacing.dart                                # Padding, border radii, elevations
│   ├── navigation/
│   │   └── main_shell.dart                                 # Persistent 4-tab bottom navigation shell
│   ├── router/
│   │   ├── app_router.dart                                 # GoRouter with ShellRoute & full-screen routes
│   │   └── route_names.dart                                # Path route constants
│   ├── theme/
│   │   ├── app_theme.dart                                  # Light & Dark Material 3 theme definitions
│   │   └── theme_provider.dart                             # Riverpod ThemeMode notifier
│   └── widgets/
│       ├── qf_app_bar.dart                                 # Standardized custom navigation headers
│       ├── qf_badge.dart                                   # Warranty, status, and tag pills
│       ├── qf_button.dart                                  # Primary & accent action buttons
│       ├── qf_card.dart                                    # Outlined rounded containers
│       ├── qf_error_view.dart                              # Empty and error retry components
│       ├── qf_shimmer.dart                                 # Skeleton loaders
│       └── qf_text_field.dart                              # Validated form text inputs
│
└── features/
    ├── splash/presentation/screens/
    │   └── splash_screen.dart                              # Animated logo, brand tagline, auto-nav
    ├── home/presentation/screens/
    │   └── home_screen.dart                                # Location header, banners, repair grid, trust section
    ├── catalog/
    │   ├── domain/models/
    │   │   ├── brand_model.dart                            # Apple, Samsung, OnePlus, Xiaomi, Pixel, etc.
    │   │   ├── device_model.dart                           # iPhone 17/16 series, Galaxy S25/S24, etc.
    │   │   └── repair_service_model.dart                   # Screen, Battery, Port, Water damage, etc.
    │   └── presentation/screens/
    │       ├── brand_selection_screen.dart                 # Responsive search & grid brand selection
    │       ├── model_selection_screen.dart                 # Series-grouped device model list
    │       └── repair_selection_screen.dart                # Multi-issue selector with live cost tally
    ├── booking/
    │   ├── domain/models/
    │   │   └── booking_draft.dart                          # Persistent Riverpod state model
    │   └── presentation/
    │       ├── controllers/
    │       │   └── booking_flow_controller.dart            # Manages draft state throughout guest flow
    │       └── screens/
    │           ├── problem_description_screen.dart         # Problem text + photo upload
    │           ├── pickup_address_screen.dart              # Address fields, GPS detect, type selector
    │           ├── pickup_scheduling_screen.dart           # Next 7-day strip + morning/evening slots
    │           ├── booking_summary_screen.dart             # Review cards, price estimate & lazy OTP sheet
    │           └── booking_success_screen.dart             # Confirmation celebration, booking ID
    ├── auth/
    │   ├── domain/models/
    │   │   └── user_model.dart                             # Authenticated customer model
    │   └── presentation/controllers/
    │       └── auth_controller.dart                        # Phone OTP verification StateNotifier
    ├── tracking/presentation/screens/
    │   └── repair_tracking_screen.dart                     # 12-stage visual timeline & driver updates
    ├── orders/presentation/screens/
    │   └── orders_screen.dart                              # Active, completed, cancelled tabs
    ├── profile/presentation/screens/
    │   └── profile_screen.dart                             # Authenticated & guest mode states
    └── support/presentation/screens/
        └── support_screen.dart                             # Call, WhatsApp, raise complaint & FAQ accordion
```

---

## 4. Complete User Journey

```
[ App Launch ]
      │
      ▼
Screen 1: Splash Screen (Animated QF Emblem + "Your Device, Our Priority")
      │
      ▼
Screen 2: Home Screen (Promotions Carousel, Popular Repairs, Why Us, How It Works)
      │
      ▼ [Tap "Book a Repair" or Category]
Screen 3: Brand Selection (Apple, Samsung, OnePlus, Xiaomi, Pixel, etc.)
      │
      ▼
Screen 4: Model Selection (Series Grouping: iPhone 17/16, Galaxy S25/S24)
      │
      ▼
Screen 5: Repair Selection (Multi-select Screen, Battery, Port, etc. + Live Cost Bar)
      │
      ▼
Screen 6: Describe Problem (Quick Chips + Text Description + Photo Upload)
      │
      ▼
Screen 7: Pickup Address (GPS Detection + House/Street/City/Pincode/Phone)
      │
      ▼
Screen 8: Schedule Pickup (7-Day Horizontal Strip + Time Slots)
      │
      ▼
Screen 9: Booking Summary (Review All Details + Transparent Pricing)
      │
      ▼ [Tap "Confirm Booking"]
Is User Signed In?
   ├── Yes ──► Confirms Order
   └── No  ──► Shows Lazy Phone OTP Bottom Sheet (Draft 100% Preserved)
                     │
                     ▼
Screen 11: Booking Confirmation (ID #QF-XXXXX, Date/Time, Free Delivery)
      │
      ▼
Screen 12: 12-Stage Visual Repair Tracker (Live Step Progression)
```

---

## 5. Verification Status
- ✅ Project builds cleanly with Flutter 3.44.8 / Dart 3.12.2
- ✅ Riverpod state management & GoRouter deep-linking fully wired
- ✅ Unit & Domain test suite passing (`4/4 tests passed`)
- ✅ Production mobile-ready architecture
