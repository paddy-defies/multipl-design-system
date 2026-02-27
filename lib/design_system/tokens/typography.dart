import 'package:flutter/material.dart';
import 'colors.dart';

/// Multipl Design System v5.0 typography tokens.
///
/// Primary font: Gilroy (400/500/600/700/800)
/// Display font: Playfair Display (wealth / onboarding headings only)
///
/// NOTE: Gilroy is a commercial typeface (Radomir Tinkov/MyFonts).
/// Confirm your team holds a valid license before shipping.
abstract final class AppTextStyles {
  static const String _gilroy = 'Gilroy';
  static const String _playfair = 'PlayfairDisplay';

  // ── Tabular figures feature tag (numeric alignment) ────────────────────────
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  // ── V5 Type Scale ──────────────────────────────────────────────────────────

  /// Display — 48px / w700 / -2% tracking
  static const TextStyle display = TextStyle(
    fontFamily: _gilroy,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.96,
    fontFeatures: _tabular,
    color: AppColors.txDark,
  );

  /// H1 — 40px / w700 / -2% tracking
  static const TextStyle h1 = TextStyle(
    fontFamily: _gilroy,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.80,
    color: AppColors.txDark,
  );

  /// H2 — 32px / w700 / -1% tracking
  static const TextStyle h2 = TextStyle(
    fontFamily: _gilroy,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.32,
    color: AppColors.txDark,
  );

  /// H3 — 24px / w600 / -1% tracking
  static const TextStyle h3 = TextStyle(
    fontFamily: _gilroy,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.24,
    color: AppColors.txDark,
  );

  /// H4 — 20px / w600 / -1% tracking
  static const TextStyle h4 = TextStyle(
    fontFamily: _gilroy,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.20,
    color: AppColors.txDark,
  );

  /// Body Large — 16px / w400 / -1% tracking
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _gilroy,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.16,
    color: AppColors.txDark,
  );

  /// Body Small — 14px / w400 / 0 tracking
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _gilroy,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.neutral600,
  );

  /// Caption Caps — 12px / w600 / +8% tracking / uppercase
  static const TextStyle captionCaps = TextStyle(
    fontFamily: _gilroy,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.96,
    color: AppColors.neutral600,
  );

  /// Caption Body — 12px / w400 / 0 tracking
  static const TextStyle captionBody = TextStyle(
    fontFamily: _gilroy,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
    color: AppColors.neutral500,
  );

  // ── Button label ───────────────────────────────────────────────────────────
  /// 16px / SemiBold — primary & secondary button labels
  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _gilroy,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.16,
    color: AppColors.txDark,
  );

  // ── Legacy aliases (backward-compat — point to closest V5 equivalent) ──────

  /// Alias → display (48px/w700). Used by HeroCard for balance amounts.
  static const TextStyle amountHero = TextStyle(
    fontFamily: _gilroy,
    fontSize: 50,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -1.0,
    fontFeatures: _tabular,
    color: AppColors.txWhite,
  );

  /// Alias → h3 (24px/w600). Medium monetary amount.
  static const TextStyle amountMedium = TextStyle(
    fontFamily: _gilroy,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.24,
    fontFeatures: _tabular,
    color: AppColors.txDark,
  );

  /// Alias → captionCaps (12px/w600). Micro labels.
  static const TextStyle labelSmall = captionCaps;

  /// Alias → h4 (20px/w600). Section titles, card headers.
  static const TextStyle titleMedium = h4;

  /// Alias → bodyLarge (16px/w400). Kept for existing usage.
  static const TextStyle titleSmall = TextStyle(
    fontFamily: _gilroy,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.14,
    color: AppColors.txDark,
  );

  /// Body Medium — 14px / w400 (alias kept for existing refs)
  static const TextStyle bodyMedium = bodySmall;

  /// Label Large — 14px / SemiBold (alias kept for existing refs)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _gilroy,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.14,
    color: AppColors.txDark,
  );

  /// Label Medium — 12px / Medium (alias kept for chip / tag usage)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _gilroy,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.12,
    color: AppColors.txDark,
  );

  /// Growth percent — 16px / SemiBold / tabular, success color
  static const TextStyle growthPercent = TextStyle(
    fontFamily: _gilroy,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: _tabular,
    color: AppColors.semanticSuccess,
  );

  // ── Display aliases mapped to V5 headings ──────────────────────────────────
  static const TextStyle displayLarge = display;
  static const TextStyle displayMedium = h1;
  static const TextStyle displaySmall = h2;
  static const TextStyle headlineLarge = h1;
  static const TextStyle headlineMedium = h2;
  static const TextStyle headlineSmall = h3;

  // ── Wealth / Playfair Display (unchanged) ──────────────────────────────────
  /// Playfair Display 28px Bold Navy
  static const TextStyle wealthDisplayHeading = TextStyle(
    fontFamily: _playfair,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.semanticNavy,
  );

  /// Playfair Display 22px SemiBold
  static const TextStyle wealthSubHeading = TextStyle(
    fontFamily: _playfair,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.semanticNavy,
  );
}

/// Builds a [TextTheme] from [AppTextStyles] for use inside [ThemeData].
TextTheme buildAppTextTheme() {
  return const TextTheme(
    displayLarge: AppTextStyles.display,
    displayMedium: AppTextStyles.h1,
    displaySmall: AppTextStyles.h2,
    headlineLarge: AppTextStyles.h1,
    headlineMedium: AppTextStyles.h2,
    headlineSmall: AppTextStyles.h3,
    titleMedium: AppTextStyles.h4,
    titleSmall: AppTextStyles.titleSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodySmall,
    bodySmall: AppTextStyles.captionBody,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.captionCaps,
  );
}
