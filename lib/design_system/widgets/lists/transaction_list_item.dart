import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/gradients.dart';

/// Multipl Design System v4.0 — Transaction List Item.
///
/// Displays a single transaction row: category icon + merchant name +
/// optional subtitle + amount + timestamp.
///
/// ```dart
/// TransactionListItem(
///   merchantName: 'Swiggy',
///   amount: '−₹485',
///   timestamp: 'Today, 1:24 PM',
///   category: BrandCategory.food,
///   isCredit: false,
/// )
/// ```
class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.merchantName,
    required this.amount,
    required this.timestamp,
    this.category,
    this.subtitle,
    this.isCredit = false,
    this.icon,
    this.onTap,
  });

  final String merchantName;
  final String amount;
  final String timestamp;
  final BrandCategory? category;
  final String? subtitle;

  /// True for credit transactions (green amount), false for debit (dark amount).
  final bool isCredit;

  /// Custom icon widget. If null, a category-colored initial is shown.
  final Widget? icon;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s12,
        ),
        child: Row(
          children: [
            _CategoryIcon(
              merchantName: merchantName,
              category: category,
              icon: icon,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchantName,
                    style: AppTextStyles.titleSmall.copyWith(color: AppColors.txDark),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.txMid),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: AppTextStyles.amountMedium.copyWith(
                    color: isCredit ? AppColors.tealText : AppColors.txDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timestamp,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.txLight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.merchantName,
    this.category,
    this.icon,
  });

  final String merchantName;
  final BrandCategory? category;
  final Widget? icon;

  Color _bgColor() {
    if (category == null) return AppColors.neutralTrack;
    switch (category!) {
      case BrandCategory.food:     return AppColors.tagFoodBg;
      case BrandCategory.shopping: return AppColors.tagShopBg;
      case BrandCategory.apparel:  return AppColors.tagApparelBg;
      case BrandCategory.cabs:     return AppColors.tagCabsBg;
    }
  }

  Color _textColor() {
    if (category == null) return AppColors.txMid;
    switch (category!) {
      case BrandCategory.food:     return AppColors.tagFoodText;
      case BrandCategory.shopping: return AppColors.tagShopText;
      case BrandCategory.apparel:  return AppColors.tagApparelText;
      case BrandCategory.cabs:     return AppColors.tagCabsText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: AppRadius.card,
      ),
      child: icon ??
          Center(
            child: Text(
              merchantName.isNotEmpty
                  ? merchantName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textColor(),
              ),
            ),
          ),
    );
  }
}
