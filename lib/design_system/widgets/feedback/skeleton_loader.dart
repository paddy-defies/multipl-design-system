import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/motion.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Multipl Design System v4.0 — Skeleton Loader.
///
/// Animated shimmer placeholder for loading states.
/// Uses [AppMotion.shimmer] duration and a left-to-right shimmer sweep.
///
/// ```dart
/// // Single skeleton block
/// SkeletonLoader(width: double.infinity, height: 80)
///
/// // Pre-built skeleton for a transaction list item
/// SkeletonTransactionItem()
///
/// // Pre-built skeleton for a card
/// SkeletonCard(height: 160)
/// ```
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.shimmer,
    )..repeat();

    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.sAll;
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                AppColors.neutralTrack,
                AppColors.bgCard,
                AppColors.neutralTrack,
              ],
              transform: _SlidingGradientTransform(_shimmer.value),
            ),
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * slidePercent,
      0,
      0,
    );
  }
}

// ── Pre-built skeletons ───────────────────────────────────────────────────────

/// Skeleton for a single transaction list item row.
class SkeletonTransactionItem extends StatelessWidget {
  const SkeletonTransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
      child: Row(
        children: [
          SkeletonLoader(
            width: 44,
            height: 44,
            borderRadius: AppRadius.card,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 120, height: 14, borderRadius: AppRadius.xsAll),
                const SizedBox(height: AppSpacing.s6),
                SkeletonLoader(width: 80, height: 10, borderRadius: AppRadius.xsAll),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonLoader(width: 60, height: 14, borderRadius: AppRadius.xsAll),
              const SizedBox(height: AppSpacing.s6),
              SkeletonLoader(width: 50, height: 10, borderRadius: AppRadius.xsAll),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton for a generic card with optional inner rows.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height = 120,
    this.margin,
  });

  final double height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SkeletonLoader(
        width: double.infinity,
        height: height,
        borderRadius: AppRadius.card,
      ),
    );
  }
}

/// Skeleton for a brand tile grid card.
class SkeletonBrandTile extends StatelessWidget {
  const SkeletonBrandTile({super.key, this.width = 140});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SkeletonLoader(
          width: width,
          height: 72,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        Container(
          width: width,
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: const BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLoader(width: 80, height: 12, borderRadius: AppRadius.xsAll),
              const SizedBox(height: AppSpacing.s6),
              SkeletonLoader(width: 60, height: 10, borderRadius: AppRadius.xsAll),
            ],
          ),
        ),
      ],
    );
  }
}
