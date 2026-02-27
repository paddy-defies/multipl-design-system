import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Badge display variants.
enum AppBadgeVariant {
  /// Small dot — no text
  dot,

  /// Circle with number count
  count,

  /// Pill with status label
  status,
}

/// Multipl Design System v5.0 — Badge component.
///
/// ```dart
/// // Notification dot
/// AppBadge(variant: AppBadgeVariant.dot, child: Icon(Icons.notifications))
///
/// // Count badge
/// AppBadge(count: 5, child: Icon(Icons.mail))
///
/// // Status pill
/// AppBadge.status(label: 'New', color: AppColors.semanticSuccess)
/// ```
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    this.child,
    this.count,
    this.label,
    this.variant = AppBadgeVariant.dot,
    this.color,
  });

  const AppBadge.status({
    super.key,
    required this.label,
    this.color,
    this.child,
  })  : variant = AppBadgeVariant.status,
        count = null;

  final Widget? child;
  final int? count;
  final String? label;
  final AppBadgeVariant variant;
  final Color? color;

  Color get _badgeColor => color ?? AppColors.coral;

  @override
  Widget build(BuildContext context) {
    if (child == null) {
      return _badgeOnly();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: -4,
          right: -4,
          child: _badgeOnly(),
        ),
      ],
    );
  }

  Widget _badgeOnly() {
    switch (variant) {
      case AppBadgeVariant.dot:
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _badgeColor,
            shape: BoxShape.circle,
          ),
        );
      case AppBadgeVariant.count:
        final displayCount = (count ?? 0) > 99 ? '99+' : '${count ?? 0}';
        return Container(
          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          decoration: BoxDecoration(
            color: _badgeColor,
            borderRadius: AppRadius.fullAll,
          ),
          child: Center(
            child: Text(
              displayCount,
              style: AppTextStyles.captionBody.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        );
      case AppBadgeVariant.status:
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s8,
            vertical: AppSpacing.s2,
          ),
          decoration: BoxDecoration(
            color: (_badgeColor).withOpacity(0.12),
            borderRadius: AppRadius.fullAll,
          ),
          child: Text(
            label ?? '',
            style: AppTextStyles.captionCaps.copyWith(color: _badgeColor),
          ),
        );
    }
  }
}
