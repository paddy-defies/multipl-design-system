import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Growth chip for dark surfaces.
///
/// Teal chip showing portfolio growth percentage on dark card backgrounds.
///
/// ```dart
/// GrowthChip(percent: 12.4)
/// GrowthChip(percent: -2.1)  // uses red for negative
/// ```
class GrowthChip extends StatelessWidget {
  const GrowthChip({
    super.key,
    required this.percent,
    this.showArrow = true,
  });

  final double percent;
  final bool showArrow;

  bool get _positive => percent >= 0;

  @override
  Widget build(BuildContext context) {
    final color = _positive ? AppColors.teal : AppColors.coral;
    final bgColor = _positive ? AppColors.tealChipBg : AppColors.coralBg;
    final borderColor = _positive ? AppColors.tealChipBdr : AppColors.formBorderError;
    final arrow = _positive ? '↑' : '↓';
    final sign = _positive ? '+' : '';
    final label = '${showArrow ? arrow : ''}$sign${percent.abs().toStringAsFixed(1)}%';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
        label,
        style: AppTextStyles.captionCaps.copyWith(color: color),
      ),
    );
  }
}
