import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Radio button with gold selected state.
///
/// ```dart
/// AppRadio<String>(
///   value: 'option_a',
///   groupValue: _selected,
///   label: 'Option A',
///   onChanged: (v) => setState(() => _selected = v),
/// )
/// ```
class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.disabled = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final bool disabled;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : () => onChanged?.call(value),
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RadioIndicator(selected: _selected),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.s10),
              Text(
                label!,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.txDark,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  const _RadioIndicator({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _RadioPainter(selected: selected),
      ),
    );
  }
}

class _RadioPainter extends CustomPainter {
  const _RadioPainter({required this.selected});

  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;

    if (selected) {
      // Gold outer circle fill
      canvas.drawCircle(
        center,
        outerRadius,
        Paint()..color = AppColors.gold,
      );
      // White inner dot
      canvas.drawCircle(
        center,
        outerRadius * 0.38,
        Paint()..color = Colors.white,
      );
    } else {
      // Unfilled circle with border
      canvas.drawCircle(
        center,
        outerRadius - 1,
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        center,
        outerRadius - 1,
        Paint()
          ..color = AppColors.neutral300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_RadioPainter old) => old.selected != selected;
}
