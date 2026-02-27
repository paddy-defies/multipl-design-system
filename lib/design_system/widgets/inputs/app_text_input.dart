import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v4.0 — Text Input component.
///
/// Handles all 6 input states: normal, focused, error, disabled, filled, password.
///
/// ```dart
/// AppTextInput(
///   label: 'Mobile Number',
///   hint: '10-digit mobile number',
///   controller: _controller,
/// )
/// ```
class AppTextInput extends StatefulWidget {
  const AppTextInput({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.controller,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.maxLines = 1,
  });

  final String? label;
  final String? hint;

  /// Non-null error string puts the field in error state and shows the message.
  final String? error;

  final TextEditingController? controller;
  final bool isPassword;
  final bool enabled;
  final TextInputType keyboardType;

  /// Widget shown inside the field on the left (e.g. currency symbol).
  final Widget? prefix;

  /// Widget shown inside the field on the right (overridden by password toggle).
  final Widget? suffix;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final int maxLines;

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late final FocusNode _focusNode;
  bool _obscure = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasError => widget.error != null && widget.error!.isNotEmpty;

  Color get _borderColor {
    if (_hasError) return AppColors.formBorderError;
    if (_isFocused) return AppColors.formBorderFocus;
    return AppColors.formBorderNormal;
  }

  double get _borderWidth => _isFocused || _hasError ? 1.5 : 1.0;

  List<BoxShadow>? get _boxShadow {
    if (_hasError) return null;
    if (_isFocused) return AppShadows.focusRingGold;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.txDark),
          ),
          const SizedBox(height: AppSpacing.s8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: AppRadius.input,
            boxShadow: _boxShadow,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            obscureText: widget.isPassword && _obscure,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            textInputAction: widget.textInputAction,
            autofocus: widget.autofocus,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.txDark),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.txLight),
              filled: true,
              fillColor: widget.enabled ? AppColors.formBg : AppColors.neutralTrack,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s16,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(color: _borderColor, width: _borderWidth),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(
                  color: _hasError ? AppColors.formBorderError : AppColors.formBorderNormal,
                  width: _hasError ? 1.5 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(
                  color: _hasError ? AppColors.formBorderError : AppColors.formBorderFocus,
                  width: 1.5,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(color: AppColors.formBorderNormal),
              ),
              prefixIcon: widget.prefix != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                      child: widget.prefix,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              suffixIcon: _buildSuffix(),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: AppSpacing.s4),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 14, color: AppColors.coral),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: Text(
                  widget.error!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.coral),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return GestureDetector(
        onTap: () => setState(() => _obscure = !_obscure),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          child: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: AppColors.txMid,
          ),
        ),
      );
    }
    if (widget.suffix != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
        child: widget.suffix,
      );
    }
    return null;
  }
}
