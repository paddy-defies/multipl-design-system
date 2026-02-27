import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/spacing.dart';
import '../../tokens/typography.dart';

/// Shows a right-side slide-in drawer.
///
/// ```dart
/// showAppDrawer(
///   context,
///   title: 'Filters',
///   child: _FilterContent(),
///   actions: [
///     AppButton(label: 'Apply', onPressed: _apply),
///   ],
/// );
/// ```
Future<T?> showAppDrawer<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  List<Widget>? actions,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Drawer',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (ctx, animation, secondaryAnimation) => _AppDrawerSheet(
      title: title,
      child: child,
      actions: actions,
    ),
    transitionBuilder: (ctx, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return Stack(
        children: [
          // Backdrop
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(curved),
            child: GestureDetector(
              onTap: () => Navigator.of(ctx).pop(),
              child: Container(
                color: AppColors.bgDark.withOpacity(0.40),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          // Panel slides in from right
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        ],
      );
    },
  );
}

class _AppDrawerSheet extends StatelessWidget {
  const _AppDrawerSheet({
    required this.title,
    required this.child,
    this.actions,
  });

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: AppColors.bgWhite,
        child: SizedBox(
          width: 340,
          height: double.infinity,
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s20,
                    AppSpacing.s20,
                    AppSpacing.s16,
                    AppSpacing.s16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(title, style: AppTextStyles.h4),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: AppRadius.sAll,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.txDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.neutralDivider),
                // Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.s20),
                    child: child,
                  ),
                ),
                // Footer actions
                if (actions != null && actions!.isNotEmpty) ...[
                  const Divider(height: 1, color: AppColors.neutralDivider),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    child: Row(
                      children: actions!
                          .map((a) => Expanded(child: a))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
