import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Step progress indicator.
///
/// ```dart
/// StepProgressIndicator(
///   steps: ['KYC', 'Bank', 'Invest'],
///   currentStep: 1,   // 0-indexed, currently active
/// )
/// ```
class StepProgressIndicator extends StatelessWidget {
  const StepProgressIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: steps.asMap().entries.map((entry) {
        final i = entry.key;
        final label = entry.value;
        final isCompleted = i < currentStep;
        final isActive = i == currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if (i > 0)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: isCompleted || isActive
                                  ? AppColors.gold
                                  : AppColors.neutralTrack,
                            ),
                          ),
                        _StepDot(
                          index: i,
                          isCompleted: isCompleted,
                          isActive: isActive,
                        ),
                        if (i < steps.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: isCompleted
                                  ? AppColors.gold
                                  : AppColors.neutralTrack,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.captionBody.copyWith(
                        color: isCompleted || isActive
                            ? AppColors.txDark
                            : AppColors.neutral500,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.isCompleted,
    required this.isActive,
  });

  final int index;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: AppColors.gold,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    if (isActive) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.gold, width: 2),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: AppTextStyles.captionCaps.copyWith(color: AppColors.gold),
          ),
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.neutral300, width: 1.5),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: AppTextStyles.captionCaps.copyWith(color: AppColors.neutral500),
        ),
      ),
    );
  }
}
