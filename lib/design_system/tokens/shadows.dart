import 'package:flutter/material.dart';
import 'colors.dart';

/// Multipl design system shadow tokens.
abstract final class AppShadows {
  // ── Elevation shadows ──────────────────────────────────────────────────────
  /// Subtle lift — cards at rest (2px y / 8px blur)
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x14000000),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Standard card elevation (4px y / 16px blur)
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  /// Floated / modal (8px y / 24px blur)
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  /// Pressed / active state — inward appearance
  static const List<BoxShadow> pressed = [
    BoxShadow(
      color: Color(0x29000000),
      offset: Offset(0, 1),
      blurRadius: 4,
    ),
  ];

  /// Success glow — used on growth chip / success state
  static const List<BoxShadow> successGlow = [
    BoxShadow(
      color: Color(0x402DB37A), // semanticSuccess @ 25%
      offset: Offset(0, 0),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  /// Brand yellow glow — CTA buttons on dark backgrounds
  static const List<BoxShadow> brandGlow = [
    BoxShadow(
      color: Color(0x66FBD748), // brandYellow @ 40%
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  /// Sheet handle bar shadow
  static const List<BoxShadow> sheet = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, -4),
      blurRadius: 16,
    ),
  ];

  /// Form input focus ring — 3px outer glow, 12% gold
  /// Applied to focused inputs, dropdowns, PIN boxes
  static const List<BoxShadow> focusRingGold = [
    BoxShadow(
      color: Color(0x1FFBD748),
      blurRadius: 0,
      spreadRadius: 3,
    ),
  ];

  /// Modal / bottom sheet overlay shadow
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x330C1220),
      blurRadius: 60,
      offset: Offset(0, -4),
    ),
  ];
}
