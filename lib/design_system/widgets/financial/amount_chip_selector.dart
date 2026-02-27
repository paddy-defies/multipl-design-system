import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Amount chip selector.
///
/// Grid of preset amount chips + optional custom input.
///
/// ```dart
/// AmountChipSelector(
///   presets: [500, 1000, 2000, 5000],
///   selected: _amount,
///   onSelected: (v) => setState(() => _amount = v),
/// )
/// ```
class AmountChipSelector extends StatefulWidget {
  const AmountChipSelector({
    super.key,
    required this.presets,
    required this.selected,
    required this.onSelected,
    this.currency = '₹',
    this.allowCustom = true,
  });

  final List<int> presets;
  final int? selected;
  final ValueChanged<int?> onSelected;
  final String currency;
  final bool allowCustom;

  @override
  State<AmountChipSelector> createState() => _AmountChipSelectorState();
}

class _AmountChipSelectorState extends State<AmountChipSelector> {
  bool _showCustomInput = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: [
        ...widget.presets.map((amount) {
          final isSelected = widget.selected == amount && !_showCustomInput;
          return _AmountChip(
            label: '${widget.currency}${_formatAmount(amount)}',
            selected: isSelected,
            onTap: () {
              setState(() => _showCustomInput = false);
              widget.onSelected(amount);
            },
          );
        }),
        if (widget.allowCustom)
          _showCustomInput
              ? _CustomAmountInput(
                  controller: _controller,
                  currency: widget.currency,
                  onChanged: (v) {
                    final parsed = int.tryParse(v.replaceAll(',', ''));
                    widget.onSelected(parsed);
                  },
                  onDone: () {
                    final v = int.tryParse(
                        _controller.text.replaceAll(',', ''));
                    if (v == null || v <= 0) {
                      setState(() => _showCustomInput = false);
                    }
                  },
                )
              : _AmountChip(
                  label: 'Custom',
                  selected: _showCustomInput,
                  onTap: () {
                    setState(() => _showCustomInput = true);
                    _controller.clear();
                  },
                  isCustom: true,
                ),
      ],
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(amount % 100000 == 0 ? 0 : 1)}L';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(amount % 1000 == 0 ? 0 : 1)}K';
    }
    return '$amount';
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.isCustom = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isCustom;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.bgCard,
          border: Border.all(
            color: selected
                ? AppColors.gold
                : isCustom
                    ? AppColors.gold
                    : AppColors.formBorderNormal,
            width: 1.5,
          ),
          borderRadius: AppRadius.chip,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: selected
                ? AppColors.btnPrimaryText
                : isCustom
                    ? AppColors.tealText
                    : AppColors.txDark,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CustomAmountInput extends StatelessWidget {
  const _CustomAmountInput({
    required this.controller,
    required this.currency,
    required this.onChanged,
    required this.onDone,
  });

  final TextEditingController controller;
  final String currency;
  final ValueChanged<String> onChanged;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 44,
      child: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.txDark),
        decoration: InputDecoration(
          prefixText: currency,
          prefixStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.neutral500,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.chip,
            borderSide:
                const BorderSide(color: AppColors.gold, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.chip,
            borderSide:
                const BorderSide(color: AppColors.gold, width: 1.5),
          ),
        ),
        onChanged: onChanged,
        onSubmitted: (_) => onDone(),
      ),
    );
  }
}
