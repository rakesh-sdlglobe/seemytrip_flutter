import 'package:flutter/material.dart';
import 'package:seemytrip/core/theme/app_colors.dart';

/// A customizable app bar with consistent styling
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? titleSpacing;
  final double toolbarHeight;
  final ShapeBorder? shape;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double leadingWidth;
  final TextStyle? titleTextStyle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final double horizontalPadding;
  final Widget? flexibleSpace;
  final double? toolbarOpacity;
  final double? bottomOpacity;

  const AppAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.titleSpacing,
    this.toolbarHeight = kToolbarHeight,
    this.shape,
    this.bottom,
    this.centerTitle = true,
    this.leadingWidth = 56.0,
    this.titleTextStyle,
    this.showBackButton = true,
    this.onBackPressed,
    this.titleFontSize,
    this.titleFontWeight = FontWeight.w600,
    this.horizontalPadding = 16.0,
    this.flexibleSpace,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
  })  : assert(title == null || titleWidget == null,
            'Cannot provide both a title and a titleWidget'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final colorScheme = theme.colorScheme;

    return AppBar(
      key: key,
      leading: leading ?? _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: titleTextStyle ??
                      theme.textTheme.titleLarge?.copyWith(
                        color: foregroundColor ?? appBarTheme.foregroundColor,
                        fontSize: titleFontSize,
                        fontWeight: titleFontWeight,
                      ),
                )
              : null),
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? appBarTheme.foregroundColor,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      shape: shape,
      centerTitle: centerTitle,
      leadingWidth: leadingWidth,
      toolbarOpacity: toolbarOpacity ?? 1.0,
      bottomOpacity: bottomOpacity ?? 1.0,
      titleTextStyle: titleTextStyle,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!automaticallyImplyLeading) return null;
    
    final modalRoute = ModalRoute.of(context);
    final canPop = modalRoute?.canPop ?? false;
    final useCloseButton = 
        modalRoute is PageRoute<dynamic> && modalRoute.fullscreenDialog;

    if (!showBackButton || !canPop) return null;

    if (useCloseButton) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: onBackPressed ?? () => Navigator.maybePop(context),
      );
    }

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      padding: const EdgeInsets.all(16.0),
      constraints: const BoxConstraints(),
      onPressed: onBackPressed ?? () => Navigator.maybePop(context),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  /// Creates a transparent app bar with a back button
  factory AppAppBar.transparent({
    Key? key,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    bool automaticallyImplyLeading = true,
    Widget? leading,
    VoidCallback? onBackPressed,
    double? titleSpacing,
    double? toolbarHeight,
    bool centerTitle = true,
    double? titleFontSize,
    FontWeight? titleFontWeight,
    Color? textColor,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      onBackPressed: onBackPressed,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: textColor,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      centerTitle: centerTitle,
      titleFontSize: titleFontSize,
      titleFontWeight: titleFontWeight,
    );
  }

  /// Creates a gradient app bar
  factory AppAppBar.gradient({
    Key? key,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    bool automaticallyImplyLeading = true,
    Widget? leading,
    VoidCallback? onBackPressed,
    double elevation = 0,
    List<Color>? gradientColors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    double? titleSpacing,
    double? toolbarHeight,
    bool centerTitle = true,
    double? titleFontSize,
    FontWeight? titleFontWeight = FontWeight.w600,
    Color? textColor,
  }) {
    return AppAppBar(
      key: key,
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      onBackPressed: onBackPressed,
      elevation: elevation,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      centerTitle: centerTitle,
      titleFontSize: titleFontSize,
      titleFontWeight: titleFontWeight,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors ?? [
              AppColors.primary,
              AppColors.primaryDark,
            ],
            begin: begin,
            end: end,
          ),
        ),
      ),
      foregroundColor: textColor ?? Colors.white,
    );
  }
}
