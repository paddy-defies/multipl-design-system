import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../buttons/app_button.dart';

/// A single brand's cashback entry in the summary.
class CashbackBrandEntry {
  const CashbackBrandEntry({
    required this.brandName,
    required this.amount,
    this.logoUrl,
  });

  final String brandName;
  final double amount;
  final String? logoUrl;
}

/// Multipl Design System v5.0 — Cashback summary card.
///
/// ```dart
/// CashbackSummaryCard(
///   totalAmount: 342.50,
///   entries: [
///     CashbackBrandEntry(brandName: 'Swiggy', amount: 125),
///     CashbackBrandEntry(brandName: 'Blinkit', amount: 217.50),
///   ],
///   onCta: () {},
/// )
/// ```
class CashbackSummaryCard extends StatelessWidget {
  const CashbackSummaryCard({
    super.key,
    required this.totalAmount,
    required this.entries,
    this.onCta,
    this.ctaLabel = 'Redeem All',
    this.currency = '₹',
  });

  final double totalAmount;
  final List<CashbackBrandEntry> entries;
  final VoidCallback? onCta;
  final String ctaLabel;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.card,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total Cashback',
                style: AppTextStyles.captionCaps.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
              const Spacer(),
              Text(
                '$currency${totalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.tealText,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s16),
            ...entries.map((e) => _BrandRow(entry: e, currency: currency)),
          ],
          if (onCta != null) ...[
            const SizedBox(height: AppSpacing.s20),
            AppButton(
              label: ctaLabel,
              onPressed: onCta,
            ),
          ],
        ],
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow({required this.entry, required this.currency});

  final CashbackBrandEntry entry;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Row(
        children: [
          if (entry.logoUrl != null)
            ClipRRect(
              borderRadius: AppRadius.xsAll,
              child: Image.network(
                entry.logoUrl!,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.neutralTrack,
                  child: Center(
                    child: Text(
                      entry.brandName[0].toUpperCase(),
                      style: AppTextStyles.captionCaps.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.neutralTrack,
                borderRadius: AppRadius.xsAll,
              ),
              child: Center(
                child: Text(
                  entry.brandName[0].toUpperCase(),
                  style: AppTextStyles.captionCaps.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Text(
              entry.brandName,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.txDark),
            ),
          ),
          Text(
            '+$currency${entry.amount.toStringAsFixed(2)}',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.tealText,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
