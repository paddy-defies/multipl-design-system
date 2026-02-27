import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Semantic type for alert banners.
enum AlertBannerType { success, error, warning, info }

/// Multipl Design System v5.0 — Inline alert banner.
///
/// ```dart
/// AlertBanner(
///   type: AlertBannerType.warning,
///   title: 'KYC pending',
///   body: 'Complete your KYC to unlock all features.',
///   onDismiss: () {},
/// )
/// ```
class AlertBanner extends StatelessWidget {
  const AlertBanner({
    super.key,
    required this.type,
    required this.title,
    this.body,
    this.onDismiss,
    this.action,
    this.actionLabel,
  });

  final AlertBannerType type;
  final String title;
  final String? body;
  final VoidCallback? onDismiss;
  final VoidCallback? action;
  final String? actionLabel;

  _BannerStyle get _style => _BannerStyle.forType(type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: _style.bgColor,
        border: Border.all(color: _style.borderColor, width: 1),
        borderRadius: AppRadius.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_style.icon, size: 20, color: _style.iconColor),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: _style.iconColor,
                  ),
                ),
                if (body != null) ...[
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    body!,
                    style: AppTextStyles.captionBody.copyWith(
                      color: AppColors.txDark,
                    ),
                  ),
                ],
                if (action != null && actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.s8),
                  GestureDetector(
                    onTap: action,
                    child: Text(
                      actionLabel!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: _style.iconColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onDismiss != null) ...[
            const SizedBox(width: AppSpacing.s8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, size: 16, color: _style.iconColor),
            ),
          ],
        ],
      ),
    );
  }
}

class _BannerStyle {
  const _BannerStyle({
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    required this.icon,
  });

  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final IconData icon;

  static _BannerStyle forType(AlertBannerType type) {
    switch (type) {
      case AlertBannerType.success:
        return const _BannerStyle(
          bgColor: AppColors.tealBgLt,
          borderColor: AppColors.tealBdrLt,
          iconColor: AppColors.tealText,
          icon: Icons.check_circle_outline,
        );
      case AlertBannerType.error:
        return const _BannerStyle(
          bgColor: AppColors.coralBg,
          borderColor: AppColors.formBorderError,
          iconColor: AppColors.coral,
          icon: Icons.error_outline,
        );
      case AlertBannerType.warning:
        return const _BannerStyle(
          bgColor: AppColors.warningBg,
          borderColor: AppColors.warning,
          iconColor: AppColors.warning,
          icon: Icons.warning_amber_outlined,
        );
      case AlertBannerType.info:
        return const _BannerStyle(
          bgColor: AppColors.blueBgLt,
          borderColor: AppColors.blueBdrLt,
          iconColor: AppColors.electricBlueText,
          icon: Icons.info_outline,
        );
    }
  }
}
