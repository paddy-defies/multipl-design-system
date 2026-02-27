import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Cashback chip for light surfaces.
///
/// Teal chip showing cashback percentage or flat amount on light backgrounds.
///
/// ```dart
/// CashbackChip(label: '5% cashback')
/// CashbackChip(label: 'Up to ₹200 cashback', icon: Icons.savings_outlined)
/// ```
class CashbackChip extends StatelessWidget {
  const CashbackChip({
    super.key,
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.tealBgLt,
        border: Border.all(color: AppColors.tealBdrLt, width: 1),
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.tealText),
            const SizedBox(width: AppSpacing.s4),
          ],
          Text(
            label,
            style: AppTextStyles.captionCaps.copyWith(
              color: AppColors.tealText,
            ),
          ),
        ],
      ),
    );
  }
}
