import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v4.0 — Earnings Display.
///
/// Shows total earnings / cashback with optional growth indicator chip.
///
/// ```dart
/// EarningsDisplay(
///   label: 'Total Savings',
///   amount: '₹2,840',
///   growthText: '+₹120 this month',
/// )
/// ```
class EarningsDisplay extends StatelessWidget {
  const EarningsDisplay({
    super.key,
    required this.label,
    required this.amount,
    this.growthText,
    this.isOnDark = false,
    this.compact = false,
  });

  /// Label above the amount (e.g. "Total Earnings").
  final String label;

  /// Formatted amount string (e.g. "₹2,840").
  final String amount;

  /// Optional growth chip text (e.g. "+₹120 this month").
  final String? growthText;

  /// Set true when displayed inside a [HeroCard] (dark context).
  final bool isOnDark;

  /// Compact mode reduces font sizes for use in secondary cards.
  final bool compact;

  Color get _labelColor =>
      isOnDark ? AppColors.txWhiteMd : AppColors.txMid;

  Color get _amountColor =>
      isOnDark ? AppColors.txWhite : AppColors.txDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: _labelColor),
        ),
        const SizedBox(height: AppSpacing.s4),
        Text(
          amount,
          style: (compact
              ? AppTextStyles.amountMedium
              : const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  fontFeatures: [FontFeature.tabularFigures()],
                ))
              .copyWith(color: _amountColor),
        ),
        if (growthText != null) ...[
          const SizedBox(height: AppSpacing.s8),
          _GrowthChip(text: growthText!, isOnDark: isOnDark),
        ],
      ],
    );
  }
}

class _GrowthChip extends StatelessWidget {
  const _GrowthChip({required this.text, required this.isOnDark});

  final String text;
  final bool isOnDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: isOnDark ? AppColors.tealChipBg : AppColors.tealBgLt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnDark ? AppColors.tealChipBdr : AppColors.tealBdrLt,
          width: 1,
        ),
        boxShadow: isOnDark ? AppShadows.glowTealChip : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up,
            size: 12,
            color: isOnDark ? AppColors.teal : AppColors.tealText,
          ),
          const SizedBox(width: AppSpacing.s4),
          Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(
              color: isOnDark ? AppColors.teal : AppColors.tealText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
