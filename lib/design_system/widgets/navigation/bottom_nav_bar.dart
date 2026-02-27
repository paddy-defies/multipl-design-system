import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/motion.dart';

/// A single tab item in [AppBottomNavBar].
class AppNavItem {
  const AppNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  final String label;
  final IconData icon;

  /// Optional distinct icon for the active state. Falls back to [icon] if null.
  final IconData? activeIcon;
}

/// Multipl Design System v4.0 — Dark Bottom Navigation Bar.
///
/// Uses a dark (96% midnight) background with gold active state treatment:
/// - Active icon sits inside a gold pill background
/// - Active label is gold
/// - Inactive labels and icons use dimmed white
///
/// ```dart
/// AppBottomNavBar(
///   currentIndex: _tab,
///   onTap: (i) => setState(() => _tab = i),
///   items: const [
///     AppNavItem(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
///     AppNavItem(label: 'Brands', icon: Icons.store_outlined),
///     AppNavItem(label: 'Add', icon: Icons.add_circle_outline),
///     AppNavItem(label: 'Activity', icon: Icons.receipt_long_outlined),
///     AppNavItem(label: 'Profile', icon: Icons.person_outline),
///   ],
/// )
/// ```
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : assert(items.length >= 2 && items.length <= 5);

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppNavItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.navBg,
        border: const Border(
          top: BorderSide(color: AppColors.borderDk, width: 1),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        children: List.generate(items.length, (i) {
          return Expanded(child: _NavTab(
            item: items[i],
            isActive: i == currentIndex,
            onTap: () => onTap(i),
          ));
        }),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final AppNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive ? AppColors.gold : AppColors.navInactiveLabel;
    final labelColor = isActive ? AppColors.navActiveLabel : AppColors.navInactiveLabel;
    final activeIcon = item.activeIcon ?? item.icon;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: AppMotion.standard,
            curve: AppMotion.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.navActiveIconBg : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              isActive ? activeIcon : item.icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedDefaultTextStyle(
            duration: AppMotion.micro,
            style: AppTextStyles.labelSmall.copyWith(
              color: labelColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
