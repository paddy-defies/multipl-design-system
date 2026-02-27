import 'package:flutter/animation.dart';

/// Multipl Design System v4.0 — Motion Tokens
///
/// Principle: motion communicates meaning, not decoration.
/// Reserve [celebration] duration for genuine user wins.
///
/// Usage pattern:
/// ```dart
/// AnimatedContainer(
///   duration: AppMotion.standard,
///   curve: AppMotion.easeOut,
/// )
/// ```
abstract final class AppMotion {
  // ── Duration Scale ──────────────────────────────────────────────────────────
  /// 150ms — press feedback, toggle flips, icon swaps
  static const Duration micro = Duration(milliseconds: 150);

  /// 300ms — chip selection, nav tab transitions, fade-in/out
  static const Duration standard = Duration(milliseconds: 300);

  /// 500ms — card entrances, bottom sheet open, staggered list reveal
  static const Duration entrance = Duration(milliseconds: 500);

  /// 600ms — spring bottom sheet open, celebration card reveal
  static const Duration spring = Duration(milliseconds: 600);

  /// 800ms — full celebration sequence: confetti + card + CTA
  static const Duration celebration = Duration(milliseconds: 800);

  /// 1500ms — earnings counter run-up, savings score count-up
  static const Duration counter = Duration(milliseconds: 1500);

  /// 1500ms — pulsing dot/ring loop (teal heartbeat)
  static const Duration pulseLoop = Duration(milliseconds: 1500);

  /// 1200ms — skeleton shimmer sweep animation
  static const Duration shimmer = Duration(milliseconds: 1200);

  // ── Easing Curves ───────────────────────────────────────────────────────────
  /// Standard deceleration — most entrances and transitions
  static const Curve easeOut = Curves.easeOut;

  /// Spring with slight overshoot — bottom sheets, celebration card
  /// CSS equivalent: cubic-bezier(0.34, 1.56, 0.64, 1)
  static const Curve springCurve = Cubic(0.34, 1.56, 0.64, 1.0);

  /// Linear — counter animations and progress bar fills
  static const Curve linear = Curves.linear;

  /// Ease in + out — looping animations (pulse ring, skeleton shimmer)
  static const Curve easeInOut = Curves.easeInOut;

  /// Ease in — elements exiting the screen
  static const Curve easeIn = Curves.easeIn;

  // ── Stagger ─────────────────────────────────────────────────────────────────
  /// 60ms delay between each item in a staggered entrance list
  static const Duration staggerItem = Duration(milliseconds: 60);

  // ── Press / Interaction Scale ────────────────────────────────────────────────
  /// Scale-down factor on press for all interactive elements (95%)
  static const double pressScale = 0.95;

  /// Scale-up factor for entrance pop animations (102%)
  static const double entranceScale = 1.02;
}
