import 'package:flutter/material.dart';
import 'colors.dart';

/// Multipl Design System v4.0 — Gradient Definitions
///
/// Rule: only [gold] CTA gradient is allowed once per screen.
/// All others are purely decorative / data-viz contexts.
abstract final class AppGradients {
  // ── Primary CTA (1 per screen maximum) ─────────────────────────────────────
  /// Gold CTA button gradient — left → right (horizontal)
  static const LinearGradient gold = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.goldGradEnd, AppColors.goldGradStart],
  );

  // ── Spending Account Card ───────────────────────────────────────────────────
  /// 3-stop blue gradient for Spending Account hero card
  static const LinearGradient spendingAccount = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.55, 1.0],
    colors: [AppColors.spendGradA, AppColors.spendGradB, AppColors.spendGradC],
  );

  // ── Insights Strip ──────────────────────────────────────────────────────────
  /// Warm gold/amber tint for promotional insight banners
  static const LinearGradient insightsStrip = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0x1FFBD748), Color(0x0AFBD748)],
  );

  // ── Progress Bars ───────────────────────────────────────────────────────────
  /// Goal progress, total return bar — teal → electric blue
  static const LinearGradient progressTeal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.teal, AppColors.electricBlue],
  );

  /// Bonus / reward tracker — gold → teal
  static const LinearGradient progressGoldTeal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.gold, AppColors.teal],
  );

  /// Lifetime savings score arc — gold → teal (achievement)
  static const LinearGradient progressScore = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.gold, AppColors.teal],
  );

  // ── Chart / Data Viz ────────────────────────────────────────────────────────
  /// Weekly bar chart active bars — teal with downward fade
  static const LinearGradient chartBarActive = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.teal, Color(0x5900D4AA)],
  );

  /// Weekly scorecard Multipl bar (slightly less fade than chartBarActive)
  static const LinearGradient scorecardMultipl = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.teal, Color(0x7300D4AA)],
  );

  // ── Carousel / Feature Backgrounds ─────────────────────────────────────────
  /// Warm gold/teal tint for relatable carousel slides
  static const LinearGradient carouselSlide = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x14FBD748), Color(0x0A00D4AA)],
  );

  // ── Score / Achievement Card Header ────────────────────────────────────────
  static const LinearGradient scoreHeader = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.bgBase, Color(0x1AFBD748)],
  );

  // ── Brand Tile Category Headers ─────────────────────────────────────────────
  static const LinearGradient brandFood = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandFoodA, AppColors.brandFoodB],
  );

  static const LinearGradient brandShopping = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandShopA, AppColors.brandShopB],
  );

  static const LinearGradient brandApparel = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandApparelA, AppColors.brandApparelB],
  );

  static const LinearGradient brandCabs = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandCabsA, AppColors.brandCabsB],
  );

  /// Returns the correct brand tile header gradient for a given [BrandCategory].
  static LinearGradient forCategory(BrandCategory cat) {
    switch (cat) {
      case BrandCategory.food:     return brandFood;
      case BrandCategory.shopping: return brandShopping;
      case BrandCategory.apparel:  return brandApparel;
      case BrandCategory.cabs:     return brandCabs;
    }
  }
}

/// Categories used for brand tiles and category tag coloring.
enum BrandCategory { food, shopping, apparel, cabs }
