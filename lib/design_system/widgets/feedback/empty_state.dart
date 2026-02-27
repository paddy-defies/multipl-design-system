import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';
import '../buttons/app_button.dart';

/// Multipl Design System v5.0 — Empty state.
///
/// ```dart
/// EmptyState(
///   icon: Icons.account_balance_wallet_outlined,
///   title: 'No transactions yet',
///   body: 'Add money to start investing and earning rewards.',
///   ctaLabel: 'Add Money',
///   onCta: () {},
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.ctaLabel,
    this.onCta,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? ctaLabel;
  final VoidCallback? onCta;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s32,
        vertical: AppSpacing.s48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.neutralTrack,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: iconColor ?? AppColors.neutral500,
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
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
          if (ctaLabel != null && onCta != null) ...[
            const SizedBox(height: AppSpacing.s24),
            AppButton(
              label: ctaLabel!,
              onPressed: onCta,
              fullWidth: false,
            ),
          ],
        ],
      ),
    );
  }
}
