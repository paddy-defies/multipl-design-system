import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../tokens/colors.dart';
import '../../tokens/typography.dart';
import '../../tokens/spacing.dart';

/// Visual style variants for [AppTopAppBar].
enum AppBarVariant {
  /// Standard light app bar on cream background.
  standard,

  /// Fully transparent — for screens with custom hero headers.
  transparent,

  /// Dark variant for use inside dark-background screens.
  dark,

  /// Shows a back button on the leading side.
  back,

  /// Replaces title with a search field.
  search,
}

/// Multipl Design System v4.0 — Top App Bar.
///
/// Implements a `PreferredSizeWidget` so it can be passed directly to
/// `Scaffold.appBar`.
///
/// ```dart
/// Scaffold(
///   appBar: AppTopAppBar(
///     title: 'Portfolio',
///     variant: AppBarVariant.back,
///     actions: [
///       IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
///     ],
///   ),
///   body: ...,
/// )
/// ```
class AppTopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopAppBar({
    super.key,
    this.title,
    this.variant = AppBarVariant.standard,
    this.actions,
    this.leading,
    this.onBack,
    this.searchHint,
    this.onSearch,
    this.centerTitle = true,
  });

  final String? title;
  final AppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final VoidCallback? onBack;
  final String? searchHint;
  final ValueChanged<String>? onSearch;
  final bool centerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  bool get _isDark =>
      variant == AppBarVariant.dark || variant == AppBarVariant.transparent;

  Color get _bgColor {
    switch (variant) {
      case AppBarVariant.standard:
      case AppBarVariant.back:
      case AppBarVariant.search:
        return AppColors.bgBase;
      case AppBarVariant.dark:
        return AppColors.bgDark;
      case AppBarVariant.transparent:
        return Colors.transparent;
    }
  }

  Color get _fgColor =>
      _isDark ? AppColors.txWhite : AppColors.txDark;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _bgColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      systemOverlayStyle: _isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: _fgColor),
      leading: _buildLeading(context),
      automaticallyImplyLeading: false,
      title: variant == AppBarVariant.search
          ? _SearchField(hint: searchHint, onSearch: onSearch, fgColor: _fgColor)
          : (title != null
              ? Text(
                  title!,
                  style: AppTextStyles.headlineSmall.copyWith(color: _fgColor),
                )
              : null),
      actions: [
        ...?actions,
        const SizedBox(width: AppSpacing.s8),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (variant == AppBarVariant.back) {
      return IconButton(
        icon: Icon(Icons.arrow_back, color: _fgColor),
        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
      );
    }
    return null;
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({this.hint, this.onSearch, required this.fgColor});

  final String? hint;
  final ValueChanged<String>? onSearch;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      autofocus: true,
      style: AppTextStyles.bodyLarge.copyWith(color: fgColor),
      decoration: InputDecoration(
        hintText: hint ?? 'Search',
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.txLight),
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
