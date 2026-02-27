import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Tab bar visual variant.
enum AppTabVariant { pill, underline }

/// Multipl Design System v5.0 — Tab bar.
///
/// Pill variant: selected tab gets gold pill background.
/// Underline variant: selected tab gets gold underline.
///
/// ```dart
/// AppTabBar(
///   tabs: ['Portfolio', 'Watchlist', 'History'],
///   selectedIndex: _tab,
///   onTabChanged: (i) => setState(() => _tab = i),
/// )
/// ```
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.variant = AppTabVariant.pill,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final AppTabVariant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppTabVariant.pill => _PillTabBar(
          tabs: tabs,
          selectedIndex: selectedIndex,
          onTabChanged: onTabChanged,
        ),
      AppTabVariant.underline => _UnderlineTabBar(
          tabs: tabs,
          selectedIndex: selectedIndex,
          onTabChanged: onTabChanged,
        ),
    };
  }
}

class _PillTabBar extends StatelessWidget {
  const _PillTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.neutralTrack,
        borderRadius: AppRadius.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tabs.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTabChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s16,
                vertical: AppSpacing.s6,
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.gold : Colors.transparent,
                borderRadius: AppRadius.chip,
              ),
              child: Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? AppColors.btnPrimaryText : AppColors.neutral600,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _UnderlineTabBar extends StatelessWidget {
  const _UnderlineTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: tabs.asMap().entries.map((entry) {
        final i = entry.key;
        final label = entry.value;
        final selected = i == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.s12,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: selected ? AppColors.txDark : AppColors.neutral500,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.gold : Colors.transparent,
                    borderRadius: AppRadius.fullAll,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
