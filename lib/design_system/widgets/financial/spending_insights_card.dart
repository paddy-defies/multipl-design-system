import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../atoms/growth_chip.dart';

/// Category spending entry for the insights card.
class SpendingEntry {
  const SpendingEntry({
    required this.category,
    required this.label,
    required this.amount,
    required this.percent, // 0.0 – 1.0 of total
    this.color,
  });

  final String category;
  final String label;
  final double amount;
  final double percent;
  final Color? color;
}

/// Multipl Design System v5.0 — Spending insights card.
///
/// Category breakdown bars + MoM growth chip.
///
/// ```dart
/// SpendingInsightsCard(
///   totalSpend: 8420,
///   momChange: 12.4,
///   entries: [
///     SpendingEntry(category: 'food', label: 'Food', amount: 3200, percent: 0.38),
///     SpendingEntry(category: 'shopping', label: 'Shopping', amount: 2800, percent: 0.33),
///   ],
/// )
/// ```
class SpendingInsightsCard extends StatelessWidget {
  const SpendingInsightsCard({
    super.key,
    required this.totalSpend,
    required this.entries,
    this.momChange,
    this.currency = '₹',
    this.title = 'Spending Insights',
  });

  final double totalSpend;
  final List<SpendingEntry> entries;
  final double? momChange;
  final String currency;
  final String title;

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
                title,
                style: AppTextStyles.h4.copyWith(color: AppColors.txDark),
              ),
              const Spacer(),
              if (momChange != null)
                GrowthChip(percent: momChange!),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            '$currency${totalSpend.toStringAsFixed(0)} this month',
            style: AppTextStyles.captionBody.copyWith(color: AppColors.neutral500),
          ),
          const SizedBox(height: AppSpacing.s20),
          ...entries.map((e) => _CategoryBar(
                entry: e,
                currency: currency,
              )),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.entry, required this.currency});

  final SpendingEntry entry;
  final String currency;

  Color get _barColor {
    if (entry.color != null) return entry.color!;
    switch (entry.category.toLowerCase()) {
      case 'food':
        return AppColors.tagFoodText;
      case 'shopping':
        return AppColors.tagShopText;
      case 'apparel':
        return AppColors.tagApparelText;
      case 'cabs':
        return AppColors.tagCabsText;
      default:
        return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                entry.label,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.txDark),
              ),
              const Spacer(),
              Text(
                '$currency${entry.amount.toStringAsFixed(0)}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.txDark,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: entry.percent.clamp(0.0, 1.0),
                backgroundColor: AppColors.neutralTrack,
                valueColor: AlwaysStoppedAnimation<Color>(_barColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
