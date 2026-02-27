import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Toast type — V5: success / failed / waiting.
enum AppToastType { success, failed, waiting }

/// Multipl Design System v5.0 — Toast notification.
///
/// Full pill shape with colored background per type.
///
/// ```dart
/// AppToast.show(
///   context,
///   title: 'Success',
///   subtitle: 'Fetched your details through mobile number',
///   type: AppToastType.success,
/// );
/// ```
class AppToast {
  AppToast._();

  static void show(
    BuildContext context, {
    required String title,
    String? subtitle,
    AppToastType type = AppToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: _ToastContent(title: title, subtitle: subtitle, type: type),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s8,
          ),
          duration: duration,
        ),
      );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({
    required this.title,
    this.subtitle,
    required this.type,
  });

  final String title;
  final String? subtitle;
  final AppToastType type;

  _ToastStyle get _style => _ToastStyle.forType(type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: _style.bgColor,
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FilledToastIcon(icon: _style.icon),
          const SizedBox(width: AppSpacing.s12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: AppTextStyles.captionBody.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToastStyle {
  const _ToastStyle({required this.bgColor, required this.icon});

  final Color bgColor;
  final IconData icon;

  static _ToastStyle forType(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return const _ToastStyle(
          bgColor: AppColors.toastSuccessBg,
          icon: Icons.check,
        );
      case AppToastType.failed:
        return const _ToastStyle(
          bgColor: AppColors.toastFailedBg,
          icon: Icons.close,
        );
      case AppToastType.waiting:
        return const _ToastStyle(
          bgColor: AppColors.toastWaitingBg,
          icon: Icons.access_time,
        );
    }
  }
}

/// Filled semi-transparent circle with a white icon inside.
/// Matches the HTML design: circle fill="rgba(255,255,255,0.25)" + white symbol.
class _FilledToastIcon extends StatelessWidget {
  const _FilledToastIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0x40FFFFFF),
              shape: BoxShape.circle,
            ),
          ),
          Icon(icon, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}
