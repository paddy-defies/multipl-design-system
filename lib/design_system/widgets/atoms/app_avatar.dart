import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';

/// Avatar size variants.
enum AppAvatarSize { xs, s, m, l, xl }

/// Multipl Design System v5.0 — Avatar component.
///
/// Supports image URL, initials fallback, and optional status dot.
///
/// ```dart
/// AppAvatar(imageUrl: 'https://...', size: AppAvatarSize.m)
/// AppAvatar(initials: 'RK', size: AppAvatarSize.l, showOnline: true)
/// ```
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AppAvatarSize.m,
    this.showOnline = false,
    this.backgroundColor,
  });

  final String? imageUrl;
  final String? initials;
  final AppAvatarSize size;
  final bool showOnline;
  final Color? backgroundColor;

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

  double get _dotSize {
    switch (size) {
      case AppAvatarSize.xs:
        return 6;
      case AppAvatarSize.s:
        return 8;
      default:
        return 10;
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case AppAvatarSize.xs:
        return AppTextStyles.captionBody;
      case AppAvatarSize.s:
        return AppTextStyles.captionCaps;
      case AppAvatarSize.m:
        return AppTextStyles.labelLarge;
      case AppAvatarSize.l:
        return AppTextStyles.h4;
      case AppAvatarSize.xl:
        return AppTextStyles.h3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _AvatarCircle(
          diameter: _diameter,
          imageUrl: imageUrl,
          initials: initials,
          backgroundColor: backgroundColor ?? AppColors.neutralTrack,
          textStyle: _textStyle,
        ),
        if (showOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: _dotSize,
              height: _dotSize,
              decoration: BoxDecoration(
                color: AppColors.semanticSuccess,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgCard, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({
    required this.diameter,
    this.imageUrl,
    this.initials,
    required this.backgroundColor,
    required this.textStyle,
  });

  final double diameter;
  final String? imageUrl;
  final String? initials;
  final Color backgroundColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      content = ClipOval(
        child: Image.network(
          imageUrl!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _InitialsContent(
            diameter: diameter,
            initials: initials,
            backgroundColor: backgroundColor,
            textStyle: textStyle,
          ),
        ),
      );
    } else {
      content = _InitialsContent(
        diameter: diameter,
        initials: initials,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
      );
    }

    return SizedBox(width: diameter, height: diameter, child: content);
  }
}

class _InitialsContent extends StatelessWidget {
  const _InitialsContent({
    required this.diameter,
    this.initials,
    required this.backgroundColor,
    required this.textStyle,
  });

  final double diameter;
  final String? initials;
  final Color backgroundColor;
  final TextStyle textStyle;

  String get _displayInitials {
    if (initials == null || initials!.isEmpty) return '?';
    final parts = initials!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return initials!.substring(0, initials!.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _displayInitials,
          style: textStyle.copyWith(color: AppColors.txDark),
        ),
      ),
    );
  }
}
