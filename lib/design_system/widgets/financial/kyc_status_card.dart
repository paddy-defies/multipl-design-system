import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../buttons/app_button.dart';

/// KYC verification status.
enum KYCStatus { pending, verified, failed }

/// Multipl Design System v5.0 — KYC status card.
///
/// ```dart
/// KYCStatusCard(
///   status: KYCStatus.pending,
///   onCta: () => Navigator.push(context, KYCFlow()),
/// )
/// ```
class KYCStatusCard extends StatelessWidget {
  const KYCStatusCard({
    super.key,
    required this.status,
    this.onCta,
    this.message,
  });

  final KYCStatus status;
  final VoidCallback? onCta;
  final String? message;

  _KYCStyle get _style => _KYCStyle.forStatus(status);

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
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _style.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(_style.icon, size: 22, color: _style.iconColor),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _style.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.txDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  message ?? _style.defaultMessage,
                  style: AppTextStyles.captionBody.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
          if (onCta != null && status != KYCStatus.verified) ...[
            const SizedBox(width: AppSpacing.s12),
            AppButton(
              label: status == KYCStatus.failed ? 'Retry' : 'Start',
              onPressed: onCta,
              fullWidth: false,
              size: AppButtonSize.small,
            ),
          ],
          if (status == KYCStatus.verified)
            const Icon(Icons.verified_outlined, color: AppColors.tealText, size: 22),
        ],
      ),
    );
  }
}

class _KYCStyle {
  const _KYCStyle({
    required this.bgColor,
    required this.borderColor,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.defaultMessage,
  });

  final Color bgColor;
  final Color borderColor;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String defaultMessage;

  static _KYCStyle forStatus(KYCStatus status) {
    switch (status) {
      case KYCStatus.pending:
        return const _KYCStyle(
          bgColor: AppColors.warningBg,
          borderColor: AppColors.warning,
          iconBg: Color(0x30FFB347),
          iconColor: AppColors.warning,
          icon: Icons.hourglass_empty_outlined,
          title: 'KYC Pending',
          defaultMessage: 'Complete your KYC to unlock investing.',
        );
      case KYCStatus.verified:
        return const _KYCStyle(
          bgColor: AppColors.tealBgLt,
          borderColor: AppColors.tealBdrLt,
          iconBg: AppColors.tealBgLt,
          iconColor: AppColors.tealText,
          icon: Icons.check_circle_outline,
          title: 'KYC Verified',
          defaultMessage: 'Your identity has been successfully verified.',
        );
      case KYCStatus.failed:
        return const _KYCStyle(
          bgColor: AppColors.coralBg,
          borderColor: AppColors.formBorderError,
          iconBg: Color(0x30E53935),
          iconColor: AppColors.coral,
          icon: Icons.cancel_outlined,
          title: 'KYC Failed',
          defaultMessage: 'Verification failed. Please try again.',
        );
    }
  }
}
