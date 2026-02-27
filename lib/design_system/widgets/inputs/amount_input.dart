import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v4.0 — Amount Input.
///
/// Large numeric input with ₹ currency prefix and optional quick-select chips.
///
/// ```dart
/// AmountInput(
///   controller: _amountController,
///   label: 'Enter Amount',
///   quickAmounts: [1000, 5000, 10000, 25000],
///   onChanged: (v) => setState(() => _amount = v),
/// )
/// ```
class AmountInput extends StatefulWidget {
  const AmountInput({
    super.key,
    this.controller,
    this.label,
    this.hint = '0',
    this.error,
    this.quickAmounts,
    this.onChanged,
    this.currencySymbol = '₹',
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? label;
  final String hint;
  final String? error;
  final List<int>? quickAmounts;
  final ValueChanged<String>? onChanged;
  final String currencySymbol;
  final bool enabled;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _isFocused = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasError => widget.error != null && widget.error!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.txMid),
          ),
          const SizedBox(height: AppSpacing.s12),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: AppRadius.input,
            boxShadow: _isFocused && !_hasError ? AppShadows.focusRingGold : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: widget.onChanged,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 42,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.0,
              color: AppColors.txDark,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 42,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.0,
                color: AppColors.txLight,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
              filled: true,
              fillColor: AppColors.formBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s20,
                vertical: AppSpacing.s20,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(
                  color: _hasError ? AppColors.formBorderError : AppColors.formBorderNormal,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(
                  color: _hasError ? AppColors.formBorderError : AppColors.formBorderNormal,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.input,
                borderSide: BorderSide(
                  color: _hasError ? AppColors.formBorderError : AppColors.formBorderFocus,
                  width: 1.5,
                ),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.s16, right: AppSpacing.s4),
                child: Text(
                  widget.currencySymbol,
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.txMid,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
        if (widget.quickAmounts != null && widget.quickAmounts!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s16),
          Wrap(
            spacing: AppSpacing.s8,
            children: widget.quickAmounts!
                .map((amount) => _QuickAmountChip(
                      amount: amount,
                      symbol: widget.currencySymbol,
                      onTap: () {
                        widget.controller?.text = amount.toString();
                        widget.onChanged?.call(amount.toString());
                      },
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  const _QuickAmountChip({
    required this.amount,
    required this.symbol,
    required this.onTap,
  });

  final int amount;
  final String symbol;
  final VoidCallback onTap;

  String _format(int v) {
    if (v >= 100000) return '$symbol${(v / 100000).toStringAsFixed(0)}L';
    if (v >= 1000) return '$symbol${(v / 1000).toStringAsFixed(0)}k';
    return '$symbol$v';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.chip,
          border: Border.all(color: AppColors.formBorderNormal),
        ),
        child: Text(
          _format(amount),
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.txDark),
        ),
      ),
    );
  }
}
