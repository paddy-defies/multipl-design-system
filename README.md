# Multipl Design System V5

A complete Flutter widget library + HTML reference for the Multipl app.

**[→ View the live design system](https://paddy-defies.github.io/multipl-design-system)**

---

## For Developers — Flutter Package

### 1. Add to your `pubspec.yaml`

```yaml
dependencies:
  multipl_design_system:
    git:
      url: https://github.com/paddy-defies/multipl-design-system.git
```

### 2. Run

```bash
flutter pub get
```

### 3. Import and use

```dart
import 'package:multipl_design_system/multipl_design_system.dart';

// Apply the theme
MaterialApp(
  theme: AppTheme.light,
  home: MyScreen(),
)

// Use components
AppButton(
  label: 'Add Money',
  variant: AppButtonVariant.primary,
  onPressed: () {},
)

AppToast.show(
  context,
  title: 'Payment successful',
  type: AppToastType.success,
);
```

---

## What's Included

### Tokens (7 files)
| File | Contents |
|------|---------|
| `colors.dart` | Full color palette — brand gold `#FBD748`, dark `#0C1220`, teal `#00D4AA`, all semantic colors |
| `gradients.dart` | Gold CTA gradient + progress, chart, and brand tile gradients |
| `radius.dart` | `button=4px`, `input=12px`, `card=16px`, `chip=pill` |
| `spacing.dart` | 8px grid scale + semantic aliases (`buttonHeight=52px`, `pagePadding=16px`) |
| `typography.dart` | Gilroy type scale — display/h1–h4/body/caption/button + Playfair Display for wealth headings |
| `shadows.dart` | Elevation levels + brand gold glow + focus ring |
| `motion.dart` | Duration constants + easing curves |

### Theme
`AppTheme.light` / `AppTheme.dark` — Material 3 `ThemeData` wired to all tokens.

### 45 Widgets

**Core**
- `AppButton` — primary (gold gradient) / secondary (gold tint) / tertiary (ghost)
- `AppTextInput` — labeled field with error/disabled/focused states
- `HeroCard` — midnight dark card with brand glows

**Atoms**
- `AppAvatar`, `AvatarStack`, `AppBadge`, `AppSpinner`
- `CategoryTag`, `CashbackChip`, `GrowthChip`
- `SocialAuthButton` — Google / Apple / Phone variants

**Inputs**
- `AmountInput`, `AppSearchBar`, `OtpInput`
- `AppRadio`, `AppCheckbox` (SVG polyline tick), `AppToggle`
- `AppPasswordField` — eye toggle + 5-bar strength meter
- `AppPhoneField` — country flag + dial code selector
- `AppTagInput` — multi-chip wrap input
- `AppStepper` — −/+ number control
- `AppCombobox` — searchable dropdown with Overlay

**Navigation**
- `TopAppBar`, `BottomNavBar`, `AppTabBar` (pill + underline variants)
- `StepProgress`

**Feedback**
- `AppToast` — success / failed / waiting (filled circle icons)
- `AlertBanner`, `AppProgressBar`, `SkeletonLoader`, `EmptyState`
- `NotificationPanel` + `NotificationItem`

**Overlays**
- `AppBottomSheet`, `AppModal`, `AppActionSheet`
- `AppDrawer` — right-side slide-in panel (`showAppDrawer()`)

**Financial**
- `GoalProgressCard`, `EarningsDisplay`, `AmountChipSelector`
- `VoucherCard`, `KycStatusCard`, `CashbackSummaryCard`, `SpendingInsightsCard`

**Cards & Lists**
- `BrandTileCard`, `TransactionListItem`

---

## Design Token Values (quick reference)

```dart
// Brand
AppColors.brandYellow   // #FBD748 — gold CTA (one per screen max)
AppColors.bgDark        // #0C1220 — midnight navy
AppColors.bgBase        // #FDFAF0 — warm cream page background
AppColors.teal          // #00D4AA — growth signal (dark surfaces only)
AppColors.tealText      // #006B55 — financial values on light (WCAG AA ✅)

// Gold gradient — always horizontal left→right
AppGradients.gold       // #FBD748 → #FBEF48, centerLeft→centerRight

// Button spec
AppRadius.button        // 4px
AppSpacing.buttonHeight // 52px
```

---

## Design References

| Resource | Link |
|----------|------|
| Live HTML design system | https://paddy-defies.github.io/multipl-design-system |
| Figma V5 file | `uopAN7oblYjEpitPMaMB0z` (internal access) |
| Figma node — Buttons | `55:9` |
| Figma node — Typography | `55:12` |
| Figma node — Forms | `120:659` |

---

## Font License

This package includes **Gilroy** typeface files. Gilroy is a commercial font by Radomir Tinkov / Radomir Tinkov Type Foundry. Ensure your team holds a valid license before shipping to production.

---

## Claude Code Integration

This repo includes a `CLAUDE.md` file. Any AI assistant (Claude Code, Cursor with Claude) working in a project that depends on this package will automatically understand:
- All 45 widget names and their props
- Token values and design rules
- The rule: never build raw layout when a design system widget exists

For Figma MCP: use file key `uopAN7oblYjEpitPMaMB0z` in Claude Code or Cursor to pull live design context directly from the source Figma file.
