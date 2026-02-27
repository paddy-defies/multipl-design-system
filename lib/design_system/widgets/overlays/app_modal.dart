import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../buttons/app_button.dart';

/// Modal semantic variant.
enum AppModalVariant { confirmation, info, destructive }

/// Multipl Design System v5.0 — Modal dialog.
///
/// ```dart
/// AppModal.show(
///   context,
///   title: 'Confirm withdrawal',
///   body: 'Are you sure you want to withdraw ₹5,000?',
///   variant: AppModalVariant.confirmation,
///   confirmLabel: 'Yes, withdraw',
///   onConfirm: () {},
///   cancelLabel: 'Cancel',
/// );
/// ```
class AppModal extends StatelessWidget {
  const AppModal({
    super.key,
    required this.title,
    this.body,
    this.variant = AppModalVariant.info,
    this.confirmLabel,
    this.onConfirm,
    this.cancelLabel,
    this.onCancel,
    this.icon,
    this.child,
  });

  final String title;
  final String? body;
  final AppModalVariant variant;
  final String? confirmLabel;
  final VoidCallback? onConfirm;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Widget? child;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? body,
    AppModalVariant variant = AppModalVariant.info,
    String? confirmLabel,
    VoidCallback? onConfirm,
    String? cancelLabel,
    VoidCallback? onCancel,
    IconData? icon,
    Widget? child,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => AppModal(
        title: title,
        body: body,
        variant: variant,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        cancelLabel: cancelLabel,
        onCancel: onCancel,
        icon: icon,
        child: child,
      ),
    );
  }

  Color get _iconColor {
    switch (variant) {
      case AppModalVariant.destructive:
        return AppColors.coral;
      case AppModalVariant.confirmation:
        return AppColors.gold;
      case AppModalVariant.info:
        return AppColors.electricBlueText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      backgroundColor: AppColors.bgCard,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: _iconColor),
              ),
              const SizedBox(height: AppSpacing.s16),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: AppColors.txDark),
            ),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral600),
              ),
            ],
            if (child != null) ...[
              const SizedBox(height: AppSpacing.s16),
              child!,
            ],
            const SizedBox(height: AppSpacing.s24),
            if (confirmLabel != null)
              AppButton(
                label: confirmLabel!,
                onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
                variant: variant == AppModalVariant.destructive
                    ? AppButtonVariant.primary
                    : AppButtonVariant.primary,
              ),
            if (cancelLabel != null) ...[
              const SizedBox(height: AppSpacing.s10),
              AppButton(
                label: cancelLabel!,
                onPressed: onCancel ?? () => Navigator.of(context).pop(false),
                variant: AppButtonVariant.tertiary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
