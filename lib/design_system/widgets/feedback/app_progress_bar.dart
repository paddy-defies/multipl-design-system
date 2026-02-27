import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Progress bar (linear) and ring (circular).
///
/// ```dart
/// // Linear
/// AppProgressBar(value: 0.65, label: '65%')
///
/// // Circular ring
/// AppProgressRing(value: 0.75, size: 64, label: '75%')
/// ```

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.height = 8,
    this.trackColor,
    this.fillColor,
  });

  final double value; // 0.0 – 1.0
  final String? label;
  final double height;
  final Color? trackColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: trackColor ?? AppColors.neutralTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                fillColor ?? AppColors.gold,
              ),
            ),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(
            label!,
            style: AppTextStyles.captionBody.copyWith(color: AppColors.neutral500),
          ),
        ],
      ],
    );
  }
}

class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.value,
    this.size = 64,
    this.strokeWidth = 6,
    this.label,
    this.centerWidget,
    this.fillColor,
    this.trackColor,
  });

  final double value; // 0.0 – 1.0
  final double size;
  final double strokeWidth;
  final String? label;
  final Widget? centerWidget;
  final Color? fillColor;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              backgroundColor: trackColor ?? AppColors.neutralTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                fillColor ?? AppColors.gold,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          if (centerWidget != null)
            centerWidget!
          else if (label != null)
            Text(
              label!,
              style: AppTextStyles.captionCaps.copyWith(
                color: AppColors.txDark,
              ),
            ),
        ],
      ),
    );
  }
}
