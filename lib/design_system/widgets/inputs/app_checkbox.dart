import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../../tokens/radius.dart';

/// Multipl Design System v5.0 — Checkbox with gold fill when checked.
///
/// ```dart
/// AppCheckbox(
///   value: _checked,
///   label: 'Remember me',
///   supportText: 'Save my login details for next time.',
///   onChanged: (v) => setState(() => _checked = v ?? false),
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.supportText,
    this.disabled = false,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final String? supportText;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : () => onChanged?.call(!value),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CheckboxBox(checked: value),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.s10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label!,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.txDark,
                      ),
                    ),
                    if (supportText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        supportText!,
                        style: AppTextStyles.captionBody.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// SVG-style polyline checkmark — points (2,6)→(5,9)→(10,3) on a 12×12 grid,
/// scaled to fill the 22×22 container.
class _CheckmarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.75
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final sx = size.width / 12;
    final sy = size.height / 12;
    final path = Path()
      ..moveTo(2 * sx, 6 * sy)
      ..lineTo(5 * sx, 9 * sy)
      ..lineTo(10 * sx, 3 * sy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) => false;
}

class _CheckboxBox extends StatelessWidget {
  const _CheckboxBox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: checked ? AppColors.gold : Colors.transparent,
        border: Border.all(
          color: checked ? AppColors.gold : AppColors.neutral300,
          width: 1.5,
        ),
        borderRadius: AppRadius.xsAll,
      ),
      child: checked
          ? CustomPaint(
              size: const Size(22, 22),
              painter: _CheckmarkPainter(),
            )
          : null,
    );
  }
}
