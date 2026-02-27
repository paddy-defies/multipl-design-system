import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import 'app_avatar.dart';

/// Multipl Design System v5.0 — Stacked avatars with overflow count.
///
/// ```dart
/// AvatarStack(
///   imageUrls: ['https://...', 'https://...', 'https://...'],
///   maxVisible: 3,
///   size: AppAvatarSize.s,
/// )
/// ```
class AvatarStack extends StatelessWidget {
  const AvatarStack({
    super.key,
    required this.imageUrls,
    this.initials,
    this.size = AppAvatarSize.s,
    this.maxVisible = 3,
    this.overlapFraction = 0.35,
  });

  final List<String> imageUrls;
  final List<String>? initials;
  final AppAvatarSize size;
  final int maxVisible;
  final double overlapFraction;

  double get _diameter {
    switch (size) {
      case AppAvatarSize.xs:
        return 24;
      case AppAvatarSize.s:
        return 32;
      case AppAvatarSize.m:
        return 40;
      case AppAvatarSize.l:
        return 48;
      case AppAvatarSize.xl:
        return 64;
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = imageUrls.take(maxVisible).toList();
    final overflow = imageUrls.length - maxVisible;
    final step = _diameter * (1 - overlapFraction);
    final totalCount = overflow > 0 ? visible.length + 1 : visible.length;
    final totalWidth = _diameter + step * (totalCount - 1);

    return SizedBox(
      width: totalWidth,
      height: _diameter,
      child: Stack(
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * step,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgCard, width: 1.5),
                ),
                child: AppAvatar(
                  imageUrl: visible[i],
                  initials: initials != null && i < initials!.length
                      ? initials![i]
                      : null,
                  size: size,
                ),
              ),
            ),
          if (overflow > 0)
            Positioned(
              left: visible.length * step,
              child: Container(
                width: _diameter,
                height: _diameter,
                decoration: BoxDecoration(
                  color: AppColors.neutralTrack,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgCard, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+$overflow',
                    style: AppTextStyles.captionCaps.copyWith(
                      color: AppColors.neutral600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
