import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v4.0 — Hero Dark Card.
///
/// The signature midnight card used for Portfolio Balance and Spending Account.
/// Features a dark background with three ambient glows and a sparkline slot.
///
/// ```dart
/// HeroCard(
///   child: Column(
///     children: [
///       Text('Portfolio Value', style: ...),
///       Text('₹1,24,500', style: AppTextStyles.amountLarge),
///     ],
///   ),
/// )
/// ```
class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s20),
    this.showGoldGlow = true,
    this.showBlueGlow = true,
    this.showTealGlow = true,
    this.minHeight,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Gold ambient glow at top-center (portfolio / wealth context).
  final bool showGoldGlow;

  /// Blue ambient glow at top-right (spending account context).
  final bool showBlueGlow;

  /// Teal ambient glow at bottom-right (growth / earnings context).
  final bool showTealGlow;

  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight ?? 0),
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Stack(
          children: [
            // Gold glow — top center
            if (showGoldGlow)
              Positioned(
                top: -40,
                left: 0,
                right: 0,
                child: Center(
                  child: _GlowCircle(
                    color: AppColors.goldGlow,
                    size: 220,
                  ),
                ),
              ),

            // Blue glow — top right
            if (showBlueGlow)
              Positioned(
                top: -30,
                right: -30,
                child: _GlowCircle(
                  color: AppColors.blueGlow,
                  size: 160,
                ),
              ),

            // Teal glow — bottom right
            if (showTealGlow)
              Positioned(
                bottom: -30,
                right: -10,
                child: _GlowCircle(
                  color: AppColors.tealChipGlow,
                  size: 140,
                ),
              ),

            // Glass border overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  border: Border.all(
                    color: AppColors.borderDk,
                    width: 1,
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// A blurred radial glow circle used as ambient light source inside [HeroCard].
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

/// A glass pill widget for use inside [HeroCard] — displays sub-account amounts.
///
/// ```dart
/// HeroGlassPill(label: 'Spending', amount: '₹12,400')
/// ```
class HeroGlassPill extends StatelessWidget {
  const HeroGlassPill({
    super.key,
    required this.label,
    required this.amount,
    this.accentColor = AppColors.teal,
  });

  final String label;
  final String amount;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s10,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgGlassHigh,
        borderRadius: AppRadius.chip,
        border: Border.all(color: AppColors.borderDk, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.txWhiteMd,
                  height: 1.2,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.txWhite,
                  height: 1.3,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
