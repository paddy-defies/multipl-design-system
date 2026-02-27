import 'package:flutter/material.dart';
import '../../tokens/colors.dart';

/// Spinner size variants.
enum AppSpinnerSize { inline, standard, page }

/// Multipl Design System v5.0 — Loading spinner.
///
/// ```dart
/// AppSpinner()                              // standard, gold
/// AppSpinner(size: AppSpinnerSize.page)     // full-screen overlay
/// AppSpinner(size: AppSpinnerSize.inline)   // 16px inline
/// ```
class AppSpinner extends StatelessWidget {
  const AppSpinner({
    super.key,
    this.size = AppSpinnerSize.standard,
    this.color,
  });

  final AppSpinnerSize size;
  final Color? color;

  double get _diameter {
    switch (size) {
      case AppSpinnerSize.inline:
        return 16;
      case AppSpinnerSize.standard:
        return 28;
      case AppSpinnerSize.page:
        return 40;
    }
  }

  double get _strokeWidth {
    switch (size) {
      case AppSpinnerSize.inline:
        return 1.5;
      case AppSpinnerSize.standard:
        return 2.5;
      case AppSpinnerSize.page:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinner = SizedBox(
      width: _diameter,
      height: _diameter,
      child: CircularProgressIndicator(
        strokeWidth: _strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.gold,
        ),
      ),
    );

    if (size == AppSpinnerSize.page) {
      return ColoredBox(
        color: AppColors.scrimLight,
        child: Center(child: spinner),
      );
    }

    return spinner;
  }
}
