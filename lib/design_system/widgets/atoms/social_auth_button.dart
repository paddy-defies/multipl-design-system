import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Social auth button variant.
enum SocialAuthVariant { google, apple, phone }

/// Multipl Design System v5.0 — Social authentication button.
///
/// ```dart
/// SocialAuthButton(
///   variant: SocialAuthVariant.google,
///   onPressed: () => _signInWithGoogle(),
/// )
/// SocialAuthButton(
///   variant: SocialAuthVariant.apple,
///   onPressed: () => _signInWithApple(),
/// )
/// SocialAuthButton(
///   variant: SocialAuthVariant.phone,
///   onPressed: () => _continueWithPhone(),
/// )
/// ```
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    super.key,
    required this.variant,
    required this.onPressed,
    this.fullWidth = true,
  });

  final SocialAuthVariant variant;
  final VoidCallback? onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      SocialAuthVariant.google => _SocialButton(
          onPressed: onPressed,
          fullWidth: fullWidth,
          backgroundColor: AppColors.bgWhite,
          borderColor: AppColors.neutral200,
          textColor: AppColors.txDark,
          label: 'Continue with Google',
          icon: _GoogleLogo(),
        ),
      SocialAuthVariant.apple => _SocialButton(
          onPressed: onPressed,
          fullWidth: fullWidth,
          backgroundColor: AppColors.bgDark,
          borderColor: Colors.transparent,
          textColor: AppColors.txWhite,
          label: 'Continue with Apple',
          icon: const Icon(Icons.apple, color: Colors.white, size: 20),
        ),
      SocialAuthVariant.phone => _SocialButton(
          onPressed: onPressed,
          fullWidth: fullWidth,
          backgroundColor: const Color(0x14FBD748),
          borderColor: const Color(0x66FBD748),
          textColor: AppColors.txDark,
          label: 'Continue with Phone',
          icon: const Icon(Icons.phone_outlined, color: AppColors.brandYellow, size: 20),
        ),
    };
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.onPressed,
    required this.fullWidth,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.label,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final bool fullWidth;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: AppSpacing.s12),
            Text(label, style: AppTextStyles.buttonLabel.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}

/// Google "G" logo — drawn as a simplified colored mark.
class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Draw a simplified circle with the Google "G" color quadrants.
    // Outer circle background (white — button bg shows through)
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // Four-color arc segments (simplified)
    const segments = [
      Color(0xFF4285F4), // Blue   — top-right
      Color(0xFF34A853), // Green  — bottom-right
      Color(0xFFFBBC05), // Yellow — bottom-left
      Color(0xFFEA4335), // Red    — top-left
    ];
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.28
      ..strokeCap = StrokeCap.butt;

    for (int i = 0; i < 4; i++) {
      arcPaint.color = segments[i];
      final startAngle = (i * 90 - 90) * (3.14159265 / 180.0);
      const sweepAngle = 90 * (3.14159265 / 180.0);
      final insetR = r - size.width * 0.14;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: insetR),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }

    // "G" horizontal bar (blue, extending to the right)
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = size.width * 0.28
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy), Offset(size.width * 0.88, cy), barPaint);
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter old) => false;
}
