import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v5.0 — Tag input with chip wrapping.
///
/// ```dart
/// AppTagInput(
///   label: 'Categories',
///   placeholder: 'Add a tag…',
///   maxTags: 8,
///   onTagsChanged: (tags) => setState(() => _tags = tags),
/// )
/// ```
class AppTagInput extends StatefulWidget {
  const AppTagInput({
    super.key,
    this.label,
    this.placeholder = 'Add a tag…',
    this.initialTags = const [],
    this.maxTags,
    this.onTagsChanged,
  });

  final String? label;
  final String placeholder;
  final List<String> initialTags;
  final int? maxTags;
  final ValueChanged<List<String>>? onTagsChanged;

  @override
  State<AppTagInput> createState() => _AppTagInputState();
}

class _AppTagInputState extends State<AppTagInput> {
  late List<String> _tags;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _canAdd =>
      widget.maxTags == null || _tags.length < widget.maxTags!;

  void _addTag(String value) {
    final tag = value.trim();
    if (tag.isEmpty || _tags.contains(tag) || !_canAdd) return;
    setState(() => _tags.add(tag));
    _controller.clear();
    widget.onTagsChanged?.call(List.unmodifiable(_tags));
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    widget.onTagsChanged?.call(List.unmodifiable(_tags));
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
        GestureDetector(
          onTap: () => _focusNode.requestFocus(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s10),
            decoration: BoxDecoration(
              color: AppColors.bgWhite,
              border: Border.all(color: AppColors.formBorderNormal),
              borderRadius: AppRadius.input,
            ),
            child: Wrap(
              spacing: AppSpacing.s6,
              runSpacing: AppSpacing.s6,
              children: [
                ..._tags.map((tag) => _TagChip(
                      label: tag,
                      onRemove: () => _removeTag(tag),
                    )),
                if (_canAdd)
                  IntrinsicWidth(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: AppTextStyles.bodyLarge,
                      textInputAction: TextInputAction.done,
                      onSubmitted: _addTag,
                      decoration: InputDecoration(
                        hintText: _tags.isEmpty ? widget.placeholder : '',
                        hintStyle: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.txLight,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s4,
                          vertical: AppSpacing.s6,
                        ),
                        constraints: const BoxConstraints(minWidth: 80),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.maxTags != null) ...[
          const SizedBox(height: AppSpacing.s4),
          Text(
            '${_tags.length}/${widget.maxTags} tags',
            style: AppTextStyles.captionBody,
          ),
        ],
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1EFBD748),
        border: Border.all(color: const Color(0x40FBD748)),
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.captionBody.copyWith(
              color: AppColors.txDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.txMid),
          ),
        ],
      ),
    );
  }
}
