import 'package:flutter/material.dart';

/// Multipl design system border radius tokens.
abstract final class AppRadius {
  // ── Base values ────────────────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double full = 999.0;

  /// Top-only rounded corners for bottom sheets (24px top radius)
  static const double sheetTop = 24.0;

  // ── Pre-built BorderRadius objects ─────────────────────────────────────────
  static const BorderRadius xsAll = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius sAll = BorderRadius.all(Radius.circular(s));
  static const BorderRadius mAll = BorderRadius.all(Radius.circular(m));
  static const BorderRadius lAll = BorderRadius.all(Radius.circular(l));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));

  /// Top-only rounded corners — used for bottom sheets and banners.
  static const BorderRadius sheetTopRadius = BorderRadius.only(
    topLeft: Radius.circular(sheetTop),
    topRight: Radius.circular(sheetTop),
  );

  /// Card default: 16px all corners
  static const BorderRadius card = lAll;

  /// Chip / pill default: full
  static const BorderRadius chip = fullAll;

  /// Button: 4px square corners (V5)
  static const BorderRadius button = xsAll;

  /// Input field: 12px
  static const BorderRadius input = mAll;
}
