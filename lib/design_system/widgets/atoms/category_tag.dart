import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Category taxonomy for brand tiles and transactions.
enum AppCategory { food, apparel, shopping, cabs, other }

/// Surface context determines which color set to use.
enum AppTagSurface { light, dark }

/// Multipl Design System v5.0 — Category tag chip.
///
/// ```dart
/// CategoryTag(category: AppCategory.food)
/// CategoryTag(category: AppCategory.shopping, surface: AppTagSurface.dark)
/// CategoryTag.custom(label: 'Travel', bg: Color(0x1AFFB347), text: Color(0xFFCC8800))
/// ```
class CategoryTag extends StatelessWidget {
  const CategoryTag({
    super.key,
    required this.category,
    this.surface = AppTagSurface.light,
  }) : _customLabel = null,
       _customBg = null,
       _customText = null;

  const CategoryTag.custom({
    super.key,
    required String label,
    required Color bg,
    required Color text,
  })  : category = AppCategory.other,
        surface = AppTagSurface.light,
        _customLabel = label,
        _customBg = bg,
        _customText = text;

  final AppCategory category;
  final AppTagSurface surface;
  final String? _customLabel;
  final Color? _customBg;
  final Color? _customText;

  String get _label {
    if (_customLabel != null) return _customLabel!;
    switch (category) {
      case AppCategory.food:
        return 'Food';
      case AppCategory.apparel:
        return 'Apparel';
      case AppCategory.shopping:
        return 'Shopping';
      case AppCategory.cabs:
        return 'Cabs';
      case AppCategory.other:
        return 'Other';
    }
  }

  Color get _bg {
    if (_customBg != null) return _customBg!;
    if (surface == AppTagSurface.dark) {
      switch (category) {
        case AppCategory.food:
          return AppColors.tagDkFoodBg;
        case AppCategory.apparel:
          return AppColors.tagDkApparelBg;
        case AppCategory.shopping:
          return AppColors.tagDkShopBg;
        case AppCategory.cabs:
          return AppColors.tagDkCabsBg;
        case AppCategory.other:
          return AppColors.bgGlass;
      }
    }
    switch (category) {
      case AppCategory.food:
        return AppColors.tagFoodBg;
      case AppCategory.apparel:
        return AppColors.tagApparelBg;
      case AppCategory.shopping:
        return AppColors.tagShopBg;
      case AppCategory.cabs:
        return AppColors.tagCabsBg;
      case AppCategory.other:
        return AppColors.neutral100;
    }
  }

  Color get _text {
    if (_customText != null) return _customText!;
    if (surface == AppTagSurface.dark) {
      switch (category) {
        case AppCategory.food:
          return AppColors.tagDkFoodText;
        case AppCategory.apparel:
          return AppColors.tagDkApparelText;
        case AppCategory.shopping:
          return AppColors.tagDkShopText;
        case AppCategory.cabs:
          return AppColors.tagDkCabsText;
        case AppCategory.other:
          return AppColors.txWhiteMd;
      }
    }
    switch (category) {
      case AppCategory.food:
        return AppColors.tagFoodText;
      case AppCategory.apparel:
        return AppColors.tagApparelText;
      case AppCategory.shopping:
        return AppColors.tagShopText;
      case AppCategory.cabs:
        return AppColors.tagCabsText;
      case AppCategory.other:
        return AppColors.neutral700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(
        _label,
        style: AppTextStyles.captionCaps.copyWith(color: _text),
      ),
    );
  }
}
