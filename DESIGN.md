# QuickFix UI Direction

## Direction

QuickFix should feel like a well-run device-care studio: clear service choices, exact prices, and calm confidence. Keep the existing forest-green, gold, charcoal, and pale-neutral palette unchanged. Use generous alignment, restrained surfaces, and a single strong action in each section.

## Foundations

- **Color source:** `lib/core/constants/app_colors.dart`. Keep the current values and use those semantic roles; do not add or substitute brand colors.
- **Typography source:** `lib/core/constants/app_typography.dart`. Keep Inter and its existing scale. Use medium weights for section headings and reserve heavy weights for prices or short brand marks.
- **Spacing and shapes:** `lib/core/constants/app_spacing.dart`. Prefer its spacing and radius values. Do not add one-off values without a layout need.
- **Icon style:** use the existing rounded Material icons consistently. Give icon-only actions descriptive tooltips and touch targets of at least 44 px.

## Home screen

- Keep the brand, sign-in, service location, search, category rail, and booking path easy to find.
- Let the campaign carousel be swipe-controlled. Do not auto-advance content or cycle search prompts while the customer is reading.
- Give campaign cards one clear headline, short supporting copy, one service assurance, and one booking action.
- Service cards must keep service names, ratings, current price, previous price, and discount legible at narrow phone widths. Favorite controls must remain independently actionable and labeled.
- Keep the location availability banner above the existing bottom navigation and preserve safe-area insets.

## Motion

Use short press feedback and state transitions. Avoid idle pulses, autoplay, or decorative motion. Respect reduced-motion preferences for nonessential transitions.

## Reference

Use the Circle Store homepage at `https://www.circlestore.in/` as a structural reference for the dark brand header, searchable category browsing, and horizontal product discovery. Do not copy its assets or replace QuickFix colors with Circle colors.

Prefer flat brand surfaces and restrained shadows. Keep existing illustration colors within the image area, and avoid decorative glows around interface chrome.
