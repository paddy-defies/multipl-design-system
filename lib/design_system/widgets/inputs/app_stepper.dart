import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v5.0 — Number stepper: [−] value [+].
///
/// ```dart
/// AppStepper(
///   value: _qty,
///   min: 1,
///   max: 10,
///   onChanged: (v) => setState(() => _qty = v),
/// )
/// ```
class AppStepper extends StatelessWidget {
  const AppStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.step = 1,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;

  @override
  Widget build(BuildContext context) {
    final canDecrement = value > min;
    final canIncrement = value < max;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(
          icon: Icons.remove,
          onPressed: canDecrement ? () => onChanged(value - step) : null,
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 56),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          alignment: Alignment.center,
          child: Text(
            '$value',
            style: AppTextStyles.h4.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          onPressed: canIncrement ? () => onChanged(value + step) : null,
        ),
      ],
    );
  }
}

class _StepButton extends StatefulWidget {
  const _StepButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  State<_StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<_StepButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: AppSpacing.buttonHeight,
          height: AppSpacing.buttonHeight,
          decoration: BoxDecoration(
            color: _hover && enabled
                ? const Color(0x14FBD748)
                : AppColors.neutral100,
            border: Border.all(
              color: _hover && enabled
                  ? const Color(0x66FBD748)
                  : AppColors.neutral200,
            ),
            borderRadius: AppRadius.xsAll,
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: enabled
                ? (_hover ? AppColors.brandYellow : AppColors.txDark)
                : AppColors.txLight,
          ),
        ),
      ),
    );
  }
}
