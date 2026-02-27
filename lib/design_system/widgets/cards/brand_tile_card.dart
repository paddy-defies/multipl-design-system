import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/gradients.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Multipl Design System v4.0 — Brand Tile Card.
///
/// Used in the "Popular Brands" section on Home. Features:
/// - Gradient header (72px) with large brand initial centered
/// - Frosted badge for cashback/reward label
/// - Title + subtitle text below
///
/// ```dart
/// BrandTileCard(
///   brandName: 'Swiggy',
///   category: BrandCategory.food,
///   badgeText: '8% rewards',
///   onTap: () {},
/// )
/// ```
class BrandTileCard extends StatefulWidget {
  const BrandTileCard({
    super.key,
    required this.brandName,
    required this.category,
    this.badgeText,
    this.subtitle,
    this.logoWidget,
    this.onTap,
    this.width = 140,
  });

  final String brandName;
  final BrandCategory category;

  /// Text shown in the frosted badge (e.g. '8% rewards').
  final String? badgeText;

  /// Optional secondary line below brand name.
  final String? subtitle;

  /// Custom logo widget shown in header. If null, shows brand initial.
  final Widget? logoWidget;

  final VoidCallback? onTap;
  final double width;

  @override
  State<BrandTileCard> createState() => _BrandTileCardState();
}

class _BrandTileCardState extends State<BrandTileCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.low,
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _GradientHeader(
                brandName: widget.brandName,
                category: widget.category,
                logoWidget: widget.logoWidget,
                badgeText: widget.badgeText,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.brandName,
                      style: AppTextStyles.titleSmall.copyWith(color: AppColors.txDark),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.txMid),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  const _GradientHeader({
    required this.brandName,
    required this.category,
    this.logoWidget,
    this.badgeText,
  });

  final String brandName;
  final BrandCategory category;
  final Widget? logoWidget;
  final String? badgeText;

  @override
  Widget build(BuildContext context) {
    final gradient = AppGradients.forCategory(category);

    return Container(
      height: 72,
      decoration: BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          Center(
            child: logoWidget ??
                Text(
                  brandName.isNotEmpty ? brandName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
          ),
          if (badgeText != null)
            Positioned(
              bottom: AppSpacing.s8,
              right: AppSpacing.s8,
              child: _FrostedBadge(text: badgeText!),
            ),
        ],
      ),
    );
  }
}

class _FrostedBadge extends StatelessWidget {
  const _FrostedBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bgGlassHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderDkMid, width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'DMSans',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
