import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// A single action item in an action sheet.
class AppActionItem {
  const AppActionItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isDestructive;
}

/// Multipl Design System v5.0 — Action sheet (bottom-up menu).
///
/// ```dart
/// AppActionSheet.show(
///   context,
///   title: 'Transfer Options',
///   actions: [
///     AppActionItem(label: 'UPI', icon: Icons.phone_android, onTap: () {}),
///     AppActionItem(label: 'Bank Transfer', icon: Icons.account_balance, onTap: () {}),
///     AppActionItem(label: 'Delete', icon: Icons.delete_outline, onTap: () {}, isDestructive: true),
///   ],
/// );
/// ```
class AppActionSheet extends StatelessWidget {
  const AppActionSheet({
    super.key,
    this.title,
    required this.actions,
    this.cancelLabel = 'Cancel',
  });

  final String? title;
  final List<AppActionItem> actions;
  final String cancelLabel;

  static Future<void> show(
    BuildContext context, {
    String? title,
    required List<AppActionItem> actions,
    String cancelLabel = 'Cancel',
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AppActionSheet(
        title: title,
        actions: actions,
        cancelLabel: cancelLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Actions card
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: AppRadius.card,
              ),
              child: Column(
                children: [
                  if (title != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s14,
                        horizontal: AppSpacing.s16,
                      ),
                      child: Text(
                        title!,
                        style: AppTextStyles.captionBody.copyWith(
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.neutralDivider),
                  ],
                  ...actions.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        if (i > 0 || title != null)
                          const Divider(height: 1, color: AppColors.neutralDivider),
                        _ActionRow(item: item),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            // Cancel card
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: AppRadius.card,
              ),
              child: _ActionRow(
                item: AppActionItem(
                  label: cancelLabel,
                  onTap: () => Navigator.of(context).pop(),
                ),
                isCancelStyle: true,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.item, this.isCancelStyle = false});

  final AppActionItem item;
  final bool isCancelStyle;

  @override
  Widget build(BuildContext context) {
    final color = item.isDestructive
        ? AppColors.coral
        : isCancelStyle
            ? AppColors.txDark
            : AppColors.txDark;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        item.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s16,
          vertical: AppSpacing.s16,
        ),
        child: Row(
          children: [
            if (item.icon != null) ...[
              Icon(item.icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.s12),
            ],
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: color,
                  fontWeight: isCancelStyle
                      ? FontWeight.w600
                      : item.isDestructive
                          ? FontWeight.w500
                          : FontWeight.w400,
                ),
                textAlign: item.icon == null ? TextAlign.center : TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
