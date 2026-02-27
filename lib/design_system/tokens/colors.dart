import 'package:flutter/material.dart';

/// Multipl design system color tokens.
/// Use `abstract final class` (Dart 3) to prevent instantiation.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color brandYellow = Color(0xFFFBD748);
  static const Color brandBlack = Color(0xFF1A1A1A);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color bgCream = Color(0xFFFDFAF0);
  static const Color bgPeach = Color(0xFFFDF0E8);
  static const Color bgWhite = Color(0xFFFFFFFF);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color semanticSuccess = Color(0xFF2DB37A);
  static const Color semanticInfoCard = Color(0xFFD6EAF8);
  static const Color semanticNavy = Color(0xFF1A2580);
  static const Color semanticError = Color(0xFFE53935);
  static const Color semanticWarning = Color(0xFFFFA726);

  // ── Neutral scale ──────────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF111111);

  // ── Category tag backgrounds ───────────────────────────────────────────────
  static const Color categoryFoodBg = Color(0xFFFFF3E0);
  static const Color categoryFoodText = Color(0xFFE65100);
  static const Color categoryApparelBg = Color(0xFFFCE4EC);
  static const Color categoryApparelText = Color(0xFFAD1457);
  static const Color categoryShoppingBg = Color(0xFFE8EAF6);
  static const Color categoryShoppingText = Color(0xFF283593);
  static const Color categoryCabsBg = Color(0xFFE8F5E9);
  static const Color categoryCabsText = Color(0xFF1B5E20);
  static const Color categoryDefaultBg = Color(0xFFF5F5F5);
  static const Color categoryDefaultText = Color(0xFF424242);

  // ── Overlay / scrim ────────────────────────────────────────────────────────
  static const Color scrim = Color(0x801A1A1A);
  static const Color scrimLight = Color(0x33000000);

  // ── Dark theme surfaces ────────────────────────────────────────────────────
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkCard = Color(0xFF2A2A3E);

  // ── V4 Canvas / Dark Backgrounds ──────────────────────────────────────────
  /// Warm cream page background — alias for bgCream
  static const Color bgBase = bgCream;
  /// White card surface — alias for bgWhite
  static const Color bgCard = bgWhite;
  /// Midnight navy — hero dark cards, modal backdrops
  static const Color bgDark = Color(0xFF0C1220);
  /// Slightly elevated dark layer — nested elements inside dark cards
  static const Color bgDark02 = Color(0xFF141B2D);
  /// Dark card surface for deepest layering
  static const Color bgSurface = Color(0xFF1A2540);

  // ── Glassmorphism (inside dark cards) ─────────────────────────────────────
  static const Color bgGlass = Color(0x0FFFFFFF);     // 6% white
  static const Color bgGlassHigh = Color(0x1AFFFFFF); // 10% white
  static const Color borderDk = Color(0x1AFFFFFF);    // 10% white — subtle border
  static const Color borderDkMid = Color(0x26FFFFFF); // 15% white — mid border

  // ── Brand Gold (v4) ───────────────────────────────────────────────────────
  /// Primary gold — alias for brandYellow; CTA only, one per screen max
  static const Color gold = brandYellow;
  static const Color goldGradStart = Color(0xFFFBEF48);
  static const Color goldGradEnd = Color(0xFFFBD748);
  static const Color goldGlow = Color(0x40FBD748);   // 25% opacity
  static const Color goldGlowSm = Color(0x26FBD748); // 15% opacity
  /// Correct text color ON gold buttons — 18.3:1 contrast ✅ (not brandBlack!)
  static const Color btnPrimaryText = Color(0xFF1A1200);

  // ── Teal — Growth Signal ──────────────────────────────────────────────────
  /// On dark surfaces only — growth chips, counters, separators
  static const Color teal = Color(0xFF00D4AA);
  /// On light surfaces — financial values, verified labels — 5.2:1 WCAG AA ✅
  static const Color tealText = Color(0xFF006B55);
  static const Color tealBgLt = Color(0x1700B48C);   // 9% — chip bg on light
  static const Color tealBdrLt = Color(0x3800B48C);  // 22% — chip border on light
  static const Color tealChipBg = Color(0x2400D4AA); // 14% — chip bg on dark cards
  static const Color tealChipBdr = Color(0x4000D4AA);// 25% — chip border on dark
  static const Color tealChipGlow = Color(0x1F00D4AA);// 12% — chip ambient glow

  // ── Electric Blue — Info & Premium ────────────────────────────────────────
  /// Vibrant accent — glows, progress bars, decorative elements
  static const Color electricBlue = Color(0xFF4A9FFF);
  /// Readable text/icon on light — 4.8:1 WCAG AA ✅
  static const Color electricBlueText = Color(0xFF2563EB);
  static const Color blueBgLt = Color(0x1F4A9FFF);   // 12%
  static const Color blueBdrLt = Color(0x4D4A9FFF);  // 30%
  static const Color blueGlow = Color(0x2E4A9FFF);   // 18%

  // ── Semantic (v4) ─────────────────────────────────────────────────────────
  /// Alias for semanticError — used as coral in components
  static const Color coral = semanticError;
  static const Color coralBg = Color(0x14E53935);     // 8%
  static const Color warning = Color(0xFFFFB347);
  static const Color warningBg = Color(0x1AFFB347);   // 10%

  // ── Text — Light Surfaces ─────────────────────────────────────────────────
  /// Primary heading/amount — 17.5:1 on bgBase ✅
  static const Color txDark = Color(0xFF0C1220);
  /// Secondary labels/body — 55% midnight ≈ 7.8:1 ✅
  static const Color txMid = Color(0x8C0C1220);
  /// Captions/placeholders/disabled — 35% midnight
  static const Color txLight = Color(0x590C1220);

  // ── Text — Dark Surfaces ──────────────────────────────────────────────────
  static const Color txWhite = Color(0xFFFFFFFF);
  static const Color txWhiteMd = Color(0xA6FFFFFF);  // 65% — secondary
  static const Color txWhiteDm = Color(0x61FFFFFF);  // 38% — tertiary
  static const Color txWhiteMt = Color(0x38FFFFFF);  // 22% — muted/hint

  // ── Neutral Structural ────────────────────────────────────────────────────
  static const Color neutralTrack = Color(0xFFF0F0F0);  // progress/slider track
  static const Color neutralBorder = Color(0xFFE0E0E0); // voucher dashed border
  static const Color neutralDivider = Color(0x0F0C1220);// 6% midnight — subtle divider

  // ── Form States ───────────────────────────────────────────────────────────
  static const Color formBorderNormal = Color(0x1F0C1220); // 12% midnight
  static const Color formBorderFocus = Color(0xFFFBD748);  // gold
  static const Color formBorderError = Color(0xFFE53935);  // coral
  static const Color formFocusRing = Color(0x1FFBD748);    // 12% gold
  static const Color formBg = Color(0xFFFFFFFF);

  // ── Navigation (dark bottom nav) ──────────────────────────────────────────
  static const Color navBg = Color(0xF50C1220);          // 96% midnight
  static const Color navActiveIconBg = Color(0x2EFBD748); // 18% gold — pill bg
  static const Color navActiveLabel = Color(0xFFFBD748);  // gold
  static const Color navInactiveLabel = Color(0x61FFFFFF);// 38% white

  // ── Spending Account Gradient ─────────────────────────────────────────────
  static const Color spendGradA = Color(0xFF1B3A8C);
  static const Color spendGradB = Color(0xFF2857C4);
  static const Color spendGradC = Color(0xFF1E4FAD);

  // ── Category Tags v4 — Light Surfaces ────────────────────────────────────
  static const Color tagFoodBg = Color(0xFFFFF0E6);
  static const Color tagFoodText = Color(0xFFC04A00);
  static const Color tagApparelBg = Color(0xFFFCEDF4);
  static const Color tagApparelText = Color(0xFFA01050);
  static const Color tagShopBg = Color(0xFFEEF0FF);
  static const Color tagShopText = Color(0xFF3040B0);
  static const Color tagCabsBg = Color(0xFFE8F8F4);
  static const Color tagCabsText = Color(0xFF006B55);

  // ── Category Tags v4 — Dark Surfaces ─────────────────────────────────────
  static const Color tagDkFoodBg = Color(0x26FF8A50);
  static const Color tagDkFoodText = Color(0xFFFF8A50);
  static const Color tagDkApparelBg = Color(0x26FF6B9D);
  static const Color tagDkApparelText = Color(0xFFFF6B9D);
  static const Color tagDkShopBg = Color(0x267B8FFF);
  static const Color tagDkShopText = Color(0xFF7B8FFF);
  static const Color tagDkCabsBg = Color(0x2600D4AA);
  static const Color tagDkCabsText = Color(0xFF00D4AA);

  // ── V5 Toast backgrounds ──────────────────────────────────────────────────
  /// Toast success background — dark green
  static const Color toastSuccessBg = Color(0xFF2A7A47);
  /// Toast failed background — dark red
  static const Color toastFailedBg = Color(0xFFB33025);
  /// Toast waiting background — amber
  static const Color toastWaitingBg = Color(0xFFCC8800);

  // ── Brand Tile Header Gradients ───────────────────────────────────────────
  static const Color brandFoodA = Color(0xFFFF5569);
  static const Color brandFoodB = Color(0xFFC42032);
  static const Color brandShopA = Color(0xFFFFB340);
  static const Color brandShopB = Color(0xFFE06800);
  static const Color brandApparelA = Color(0xFFFF55A3);
  static const Color brandApparelB = Color(0xFFC00870);
  static const Color brandCabsA = Color(0xFF2E2E2E);
  static const Color brandCabsB = Color(0xFF0A0A0A);
}
