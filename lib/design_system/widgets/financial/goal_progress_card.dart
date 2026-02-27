import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/gradients.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v4.0 — Goal Progress Card.
///
/// Displays a savings/investment goal with a gradient progress bar.
///
/// ```dart
/// GoalProgressCard(
///   goalName: 'Emergency Fund',
///   currentAmount: 45000,
///   targetAmount: 100000,
///   progressPercent: 45,
/// )
/// ```
class GoalProgressCard extends StatelessWidget {
  const GoalProgressCard({
    super.key,
    required this.goalName,
    required this.currentAmount,
    required this.targetAmount,
    required this.progressPercent,
    this.subtitle,
    this.onTap,
    this.currencySymbol = '₹',
  });

  final String goalName;
  final double currentAmount;
  final double targetAmount;
  final double progressPercent;
  final String? subtitle;
  final VoidCallback? onTap;
  final String currencySymbol;

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '$currencySymbol${(amount / 100000).toStringAsFixed(1)}L';
    }
    if (amount >= 1000) {
      return '$currencySymbol${(amount / 1000).toStringAsFixed(1)}k';
    }
    return '$currencySymbol${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = (progressPercent / 100).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.low,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goalName,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.txDark,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.txMid,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '${progressPercent.toInt()}%',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.tealText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s12),
            // Progress bar
            _GradientProgressBar(progress: progress),
            const SizedBox(height: AppSpacing.s10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatAmount(currentAmount),
                  style: AppTextStyles.amountMedium.copyWith(
                    fontSize: 16,
                    color: AppColors.tealText,
                  ),
                ),
                Text(
                  'of ${_formatAmount(targetAmount)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.txMid,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  const _GradientProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.neutralTrack,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.progressTeal,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
