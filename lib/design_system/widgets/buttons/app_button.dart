import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/gradients.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';
import '../../tokens/motion.dart';

/// Button style variants for [AppButton].
///
/// V5: 3 variants — primary / secondary / tertiary (ghost).
/// Removed: destructive, primaryDark.
enum AppButtonVariant {
  /// Gold gradient, pill radius, dark text. Primary CTA — one per screen max.
  primary,

  /// Cream/light bg, outlined border, dark text. Secondary actions.
  secondary,

  /// Ghost/text-only, teal text. Tertiary / inline actions.
  tertiary,
}

/// Button size scale.
enum AppButtonSize {
  /// 52px height — standard CTA.
  large,

  /// 44px height — compact / inline actions.
  small,
}

/// Multipl Design System v5.0 — Button component.
///
/// ```dart
/// AppButton(
///   label: 'Add Money',
///   onPressed: () {},
///   variant: AppButtonVariant.primary,
/// )
/// ```
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.leadingIcon,
    this.trailingIcon,
    this.loading = false,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool loading;
  final bool fullWidth;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.loading;
    final height = widget.size == AppButtonSize.large
        ? AppSpacing.buttonHeight
        : AppSpacing.buttonHeightSmall;

    return AnimatedScale(
      scale: _pressed && !isDisabled ? AppMotion.pressScale : 1.0,
      duration: AppMotion.micro,
      curve: AppMotion.easeOut,
      child: GestureDetector(
        onTapDown: isDisabled ? null : _onTapDown,
        onTapUp: isDisabled ? null : _onTapUp,
        onTapCancel: isDisabled ? null : _onTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: Opacity(
          opacity: isDisabled && !widget.loading ? 0.45 : 1.0,
          child: _buildButtonBody(height),
        ),
      ),
    );
  }

  Widget _buildButtonBody(double height) {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return _PrimaryButton(
          label: widget.label,
          height: height,
          loading: widget.loading,
          leadingIcon: widget.leadingIcon,
          trailingIcon: widget.trailingIcon,
          fullWidth: widget.fullWidth,
        );
      case AppButtonVariant.secondary:
        return _SecondaryButton(
          label: widget.label,
          height: height,
          loading: widget.loading,
          leadingIcon: widget.leadingIcon,
          trailingIcon: widget.trailingIcon,
          fullWidth: widget.fullWidth,
        );
      case AppButtonVariant.tertiary:
        return _TertiaryButton(
          label: widget.label,
          height: height,
          loading: widget.loading,
          pressed: _pressed,
          leadingIcon: widget.leadingIcon,
          trailingIcon: widget.trailingIcon,
          fullWidth: widget.fullWidth,
        );
    }
  }
}

// ── Primary (gold gradient, pill) ────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.height,
    required this.loading,
    this.leadingIcon,
    this.trailingIcon,
    required this.fullWidth,
  });

  final String label;
  final double height;
  final bool loading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: AppGradients.gold,
        borderRadius: AppRadius.button,
        boxShadow: AppShadows.brandGlow,
      ),
      child: _ButtonContent(
        label: label,
        loading: loading,
        textColor: AppColors.btnPrimaryText,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      ),
    );
  }
}

// ── Secondary (cream bg + outline) ───────────────────────────────────────────

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.height,
    required this.loading,
    this.leadingIcon,
    this.trailingIcon,
    required this.fullWidth,
  });

  final String label;
  final double height;
  final bool loading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: const Color(0x14FBD748),
        border: Border.all(color: const Color(0x66FBD748)),
        borderRadius: AppRadius.button,
      ),
      child: _ButtonContent(
        label: label,
        loading: loading,
        textColor: AppColors.txDark,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      ),
    );
  }
}

// ── Tertiary (ghost / text-only) ──────────────────────────────────────────────

class _TertiaryButton extends StatelessWidget {
  const _TertiaryButton({
    required this.label,
    required this.height,
    required this.loading,
    required this.pressed,
    this.leadingIcon,
    this.trailingIcon,
    required this.fullWidth,
  });

  final String label;
  final double height;
  final bool loading;
  final bool pressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: _ButtonContent(
        label: label,
        loading: loading,
        textColor: AppColors.txDark,
        textDecoration: pressed ? TextDecoration.underline : TextDecoration.none,
        leadingIcon: leadingIcon,
        trailingIcon: trailingIcon,
      ),
    );
  }
}

// ── Shared button content ─────────────────────────────────────────────────────

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.loading,
    required this.textColor,
    this.textDecoration = TextDecoration.none,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final bool loading;
  final Color textColor;
  final TextDecoration textDecoration;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          IconTheme(data: IconThemeData(color: textColor, size: 18), child: leadingIcon!),
          const SizedBox(width: AppSpacing.s8),
        ],
        Text(
          label,
          style: AppTextStyles.buttonLabel.copyWith(
            color: textColor,
            decoration: textDecoration,
            decorationColor: textColor,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.s8),
          IconTheme(data: IconThemeData(color: textColor, size: 18), child: trailingIcon!),
        ],
      ],
    );
  }
}
