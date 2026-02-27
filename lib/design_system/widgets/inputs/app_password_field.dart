import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Password strength level.
enum PasswordStrength { empty, weak, fair, good, strong }

/// Multipl Design System v5.0 — Password input with eye-toggle and strength meter.
///
/// ```dart
/// AppPasswordField(
///   controller: _pwController,
///   label: 'Password',
///   onStrengthChanged: (s) => print(s),
/// )
/// ```
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.placeholder = 'Enter password',
    this.onChanged,
    this.onStrengthChanged,
    this.showStrengthMeter = true,
  });

  final TextEditingController? controller;
  final String label;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<PasswordStrength>? onStrengthChanged;
  final bool showStrengthMeter;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  late final TextEditingController _controller;
  bool _obscure = true;
  PasswordStrength _strength = PasswordStrength.empty;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    final strength = _evaluate(text);
    if (strength != _strength) {
      setState(() => _strength = strength);
      widget.onStrengthChanged?.call(strength);
    }
    widget.onChanged?.call(text);
  }

  PasswordStrength _evaluate(String pw) {
    if (pw.isEmpty) return PasswordStrength.empty;
    int score = 0;
    if (pw.length >= 8) score++;
    if (pw.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(pw)) score++;
    if (RegExp(r'[0-9]').hasMatch(pw)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pw)) score++;
    if (score <= 1) return PasswordStrength.weak;
    if (score == 2) return PasswordStrength.fair;
    if (score == 3) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: AppTextStyles.labelLarge),
        const SizedBox(height: AppSpacing.s8),
        TextField(
          controller: _controller,
          obscureText: _obscure,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.txLight),
            filled: true,
            fillColor: AppColors.bgWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s14,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: AppColors.formBorderNormal),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: AppColors.formBorderNormal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: const BorderSide(color: AppColors.formBorderFocus, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.txMid,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        if (widget.showStrengthMeter) ...[
          const SizedBox(height: AppSpacing.s8),
          _StrengthMeter(strength: _strength),
        ],
      ],
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  const _StrengthMeter({required this.strength});

  final PasswordStrength strength;

  int get _filledBars => switch (strength) {
        PasswordStrength.empty => 0,
        PasswordStrength.weak => 1,
        PasswordStrength.fair => 2,
        PasswordStrength.good => 3,
        PasswordStrength.strong => 5,
      };

  Color _barColor(int index) {
    if (index >= _filledBars) return AppColors.neutral200;
    return switch (strength) {
      PasswordStrength.empty => AppColors.neutral200,
      PasswordStrength.weak => AppColors.semanticError,
      PasswordStrength.fair => AppColors.semanticWarning,
      PasswordStrength.good => AppColors.brandYellow,
      PasswordStrength.strong => AppColors.semanticSuccess,
    };
  }

  String get _label => switch (strength) {
        PasswordStrength.empty => '',
        PasswordStrength.weak => 'Weak',
        PasswordStrength.fair => 'Fair',
        PasswordStrength.good => 'Good',
        PasswordStrength.strong => 'Strong',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                decoration: BoxDecoration(
                  color: _barColor(i),
                  borderRadius: AppRadius.xsAll,
                ),
              ),
            );
          }),
        ),
        if (_label.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(
            _label,
            style: AppTextStyles.captionBody.copyWith(color: _barColor(0)),
          ),
        ],
      ],
    );
  }
}
