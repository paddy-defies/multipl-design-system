import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v5.0 — Search bar.
///
/// States: default / active (gold border) / with results.
///
/// ```dart
/// AppSearchBar(
///   hint: 'Search brands...',
///   onChanged: (q) => _filter(q),
///   onClear: () => _reset(),
/// )
/// ```
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hint = 'Search',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode _focus;
  bool _hasFocus = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focus = FocusNode()
      ..addListener(() {
        setState(() => _hasFocus = _focus.hasFocus);
      });
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: AppColors.formBg,
        border: Border.all(
          color: _hasFocus ? AppColors.formBorderFocus : AppColors.formBorderNormal,
          width: _hasFocus ? 1.5 : 1,
        ),
        borderRadius: AppRadius.input,
        boxShadow: _hasFocus
            ? [
                BoxShadow(
                  color: AppColors.formFocusRing,
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.s16),
          Icon(
            Icons.search,
            size: 20,
            color: _hasFocus ? AppColors.gold : AppColors.neutral500,
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              autofocus: widget.autofocus,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.txDark),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.txLight,
                ),
                border: InputBorder.none,
              ),
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
            ),
          ),
          if (_hasText) ...[
            GestureDetector(
              onTap: () {
                _controller.clear();
                widget.onClear?.call();
                widget.onChanged?.call('');
              },
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.s8),
                child: Icon(Icons.cancel, size: 18, color: AppColors.neutral400),
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
          ] else
            const SizedBox(width: AppSpacing.s16),
        ],
      ),
    );
  }
}
