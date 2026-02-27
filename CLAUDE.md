# Multipl — AI Context (CLAUDE.md)

## Project Overview
Flutter fintech app with a complete in-house design system (V5).
Never build raw layout using hardcoded colors, radii, or spacing when a widget already exists.

---

## Design System — Widget Library

**Location:** `lib/design_system/`
**Barrel import:** `import 'design_system/widgets/widgets.dart';`

### 45 Widgets — complete list

**Core (P0)**
- `AppButton` — primary (gold gradient) / secondary (gold tint) / tertiary (ghost)
- `AppTextInput` — labeled text field with error/disabled states
- `HeroCard` — dark midnight card with glow effects

**Navigation & Feedback (P1)**
- `BottomNavBar`, `TopAppBar`, `AppTabBar`, `StepProgress`
- `TransactionListItem`
- `AppBottomSheet`, `AppModal`, `AppActionSheet`
- `AppToast` (success/failed/waiting — filled circle icons)
- `AlertBanner`, `AppProgressBar`, `EmptyState`, `SkeletonLoader`

**Atoms (P2)**
- `AppAvatar`, `AvatarStack`, `AppBadge`, `AppSpinner`
- `CategoryTag`, `CashbackChip`, `GrowthChip`
- `SocialAuthButton` (google / apple / phone)

**Inputs & Form Controls (P3)**
- `AmountInput`, `AppSearchBar`, `OtpInput`
- `AppRadio`, `AppCheckbox` (SVG polyline tick), `AppToggle`
- `AppPasswordField` (eye toggle + 5-bar strength meter)
- `AppPhoneField` (flag + country code selector)
- `AppTagInput` (multi-chip wrap input)
- `AppStepper` (−/+ number control)
- `AppCombobox` (searchable select with Overlay dropdown)

**Overlays (P4)**
- `AppDrawer` (right-side slide-in) — use `showAppDrawer(context, title:, child:)`

**Feedback (P4)**
- `NotificationPanel` + `NotificationItem`

**Financial (P4)**
- `GoalProgressCard`, `EarningsDisplay`, `AmountChipSelector`
- `VoucherCard`, `KycStatusCard`, `CashbackSummaryCard`, `SpendingInsightsCard`

---

## Token Files

**Location:** `lib/design_system/tokens/`

| File | Key values |
|------|------------|
| `colors.dart` | `brandYellow #FBD748`, `bgBase #FDFAF0`, `bgDark #0C1220`, `teal #00D4AA`, `tealText #006B55` |
| `gradients.dart` | `AppGradients.gold` — horizontal left→right `#FBD748 → #FBEF48` |
| `radius.dart` | `button = 4px`, `input = 12px`, `card = 16px`, `chip = pill` |
| `spacing.dart` | `buttonHeight = 52px`, `buttonHeightSmall = 44px`, `pagePadding = 16px` |
| `typography.dart` | Gilroy font: `buttonLabel 16px/w600/-0.16`, `bodyLarge 16px/w400`, `bodySmall 14px/w400` |

---

## Critical Rules

### Button
```dart
// ✅ Primary — gold gradient, 4px radius, 52px height, dark text
AppButton(label: 'Add Money', onPressed: () {}, variant: AppButtonVariant.primary)

// ✅ Secondary — pale gold tint bg rgba(251,215,72,0.08), gold tint border
AppButton(label: 'Learn More', onPressed: () {}, variant: AppButtonVariant.secondary)

// ✅ Tertiary — transparent, dark text, underline on press
AppButton(label: 'Skip', onPressed: () {}, variant: AppButtonVariant.tertiary)

// ❌ Never use raw ElevatedButton or hardcode colors
```

### Gold Gradient
```dart
// ✅ Use the token
gradient: AppGradients.gold  // centerLeft→centerRight, #FBD748→#FBEF48

// ❌ Never use old diagonal gradient or old gold #F5C842 / #F0A832
```

### Colors
- `brandYellow = #FBD748` (gold CTA, one per screen max)
- Never use gold as body text on light bg (contrast too low)
- `tealText (#006B55)` for financial values on light bg — WCAG AA compliant
- `teal (#00D4AA)` on dark surfaces only

### Forms
- Focused border: `formBorderFocus = #FBD748`
- Error border: `formBorderError = #E53935`
- Input radius: `AppRadius.input (12px)` — not button radius

---

## Figma Source of Truth

**V5 File key:** `uopAN7oblYjEpitPMaMB0z`
**HTML design system (local):** `/Users/paddyraghavan/Multipl-screens-v2/design-system-v5.html`
**Figma capture reference:** file `34aBaosjAPkiqZ37nn6c7a`, page "Design System Only Multipl Reference v9"

Key Figma node IDs:
- Typography: `55:12`
- Buttons: `55:9`
- Toast: `120:640`
- Forms: `120:659`
- Radio/Checkbox/Toggle: `143:76`, `143:77`, `143:78`

---

## Font
Gilroy (commercial license required). TTF files at:
- `assets/fonts/Gilroy/` (Flutter assets)
- `pubspec.yaml` declares weights 400/500/600/700/800

Playfair Display = wealth/onboarding headings only (not general UI).
