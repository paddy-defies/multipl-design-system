import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';

/// Voucher status.
enum VoucherStatus { active, expired, used }

/// Multipl Design System v5.0 — Voucher card.
///
/// Dashed border, copy-able code slot. Active/expired/used states.
///
/// ```dart
/// VoucherCard(
///   title: 'Swiggy 20% Off',
///   code: 'MULT20SW',
///   expiry: 'Valid till 31 Mar 2025',
///   discount: '20% off upto ₹100',
///   status: VoucherStatus.active,
/// )
/// ```
class VoucherCard extends StatelessWidget {
  const VoucherCard({
    super.key,
    required this.title,
    required this.code,
    this.expiry,
    this.discount,
    this.logoUrl,
    this.status = VoucherStatus.active,
    this.onCopy,
    this.onRedeem,
  });

  final String title;
  final String code;
  final String? expiry;
  final String? discount;
  final String? logoUrl;
  final VoucherStatus status;
  final VoidCallback? onCopy;
  final VoidCallback? onRedeem;

  bool get _active => status == VoucherStatus.active;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _active ? 1.0 : 0.6,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          border: Border.all(
            color: AppColors.neutralBorder,
            width: 1.5,
          ),
          borderRadius: AppRadius.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (logoUrl != null) ...[
                  ClipRRect(
                    borderRadius: AppRadius.xsAll,
                    child: Image.network(
                      logoUrl!,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 36,
                        height: 36,
                        color: AppColors.neutralTrack,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.txDark,
                    ),
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),
            if (discount != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                discount!,
                style: AppTextStyles.captionCaps.copyWith(
                  color: AppColors.tealText,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.s12),
            // Dashed code box
            _DashedCodeBox(
              code: code,
              active: _active,
              onCopy: _active
                  ? () {
                      Clipboard.setData(ClipboardData(text: code));
                      onCopy?.call();
                    }
                  : null,
            ),
            if (expiry != null) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                expiry!,
                style: AppTextStyles.captionBody.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashedCodeBox extends StatelessWidget {
  const _DashedCodeBox({
    required this.code,
    required this.active,
    this.onCopy,
  });

  final String code;
  final bool active;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: active ? AppColors.gold : AppColors.neutralBorder,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s14,
          vertical: AppSpacing.s10,
        ),
        child: Row(
          children: [
            Text(
              code,
              style: AppTextStyles.labelLarge.copyWith(
                color: active ? AppColors.txDark : AppColors.neutral500,
                letterSpacing: 3,
              ),
            ),
            const Spacer(),
            if (onCopy != null)
              GestureDetector(
                onTap: onCopy,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy_outlined, size: 14, color: AppColors.tealText),
                    const SizedBox(width: AppSpacing.s4),
                    Text(
                      'Copy',
                      style: AppTextStyles.captionCaps.copyWith(
                        color: AppColors.tealText,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final VoucherStatus status;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case VoucherStatus.active:
        bg = AppColors.tealBgLt;
        text = AppColors.tealText;
        label = 'ACTIVE';
      case VoucherStatus.expired:
        bg = AppColors.coralBg;
        text = AppColors.coral;
        label = 'EXPIRED';
      case VoucherStatus.used:
        bg = AppColors.neutral100;
        text = AppColors.neutral600;
        label = 'USED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s2,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.fullAll,
      ),
      child: Text(label, style: AppTextStyles.captionCaps.copyWith(color: text)),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 8.0;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(radius),
      ));

    final dashedPath = _dashPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(Path source, double dashWidth, double dashSpace) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0, metric.length);
        dest.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
