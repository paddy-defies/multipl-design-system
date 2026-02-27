import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v5.0 — Searchable combobox with Overlay dropdown.
///
/// ```dart
/// AppCombobox(
///   label: 'Category',
///   options: ['Food', 'Travel', 'Shopping'],
///   onSelected: (v) => setState(() => _category = v),
/// )
/// ```
class AppCombobox extends StatefulWidget {
  const AppCombobox({
    super.key,
    required this.options,
    this.label,
    this.placeholder = 'Select or search…',
    this.initialValue,
    this.onSelected,
  });

  final List<String> options;
  final String? label;
  final String placeholder;
  final String? initialValue;
  final ValueChanged<String>? onSelected;

  @override
  State<AppCombobox> createState() => _AppComboboxState();
}

class _AppComboboxState extends State<AppCombobox> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _entry;
  List<String> _filtered = [];
  String? _selected;

  @override
  void initState() {
    super.initState();
    _filtered = widget.options;
    _selected = widget.initialValue;
    if (_selected != null) _controller.text = _selected!;
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _removeOverlay();
    final box = context.findRenderObject() as RenderBox;
    final fullWidth = box.size.width;
    _entry = OverlayEntry(
      builder: (_) => Positioned(
        width: fullWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          // Offset relative to CompositedTransformTarget (the TextField only).
          offset: const Offset(0, AppSpacing.inputHeight + 4),
          child: _DropdownOverlay(
            items: _filtered,
            selected: _selected,
            onSelect: _onSelect,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void _onSelect(String value) {
    setState(() {
      _selected = value;
      _controller.text = value;
      _filtered = widget.options;
    });
    _focusNode.unfocus();
    widget.onSelected?.call(value);
  }

  void _onChanged(String query) {
    setState(() {
      _filtered = query.isEmpty
          ? widget.options
          : widget.options
              .where((o) => o.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
    _entry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.s8),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: AppTextStyles.bodyLarge,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.txLight),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                child: Icon(Icons.search, size: 18, color: AppColors.txMid),
              ),
              prefixIconConstraints: const BoxConstraints(),
              suffixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s12),
                child: Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.txMid),
              ),
              suffixIconConstraints: const BoxConstraints(),
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
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownOverlay extends StatelessWidget {
  const _DropdownOverlay({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<String> items;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Material(
      elevation: 8,
      shadowColor: const Color(0x1A0C1220),
      borderRadius: AppRadius.input,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 240),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: AppRadius.input,
          border: Border.all(color: AppColors.formBorderNormal),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final isSelected = item == selected;
            return _DropdownItem(
              label: item,
              isSelected: isSelected,
              onTap: () => onSelect(item),
            );
          },
        ),
      ),
    );
  }
}

class _DropdownItem extends StatelessWidget {
  const _DropdownItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isSelected ? AppColors.txDark : AppColors.txMid,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, size: 16, color: AppColors.brandYellow),
          ],
        ),
      ),
    );
  }
}
