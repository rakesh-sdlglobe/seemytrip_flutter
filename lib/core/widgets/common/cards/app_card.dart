import 'package:flutter/material.dart';

/// A modern and customizable card widget with professional styling
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    Key? key,
    this.onTap,
    this.color,
    this.width,
    this.height,
    this.elevation = 4.0,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(20.0),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.borderSide,
    this.showShadow = true,
    this.clipBehavior = Clip.antiAlias,
    this.gradient,
    this.surfaceTintColor = Colors.transparent,
    this.shadowColor = Colors.black26,
    this.border,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final double? width;
  final double? height;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderSide? borderSide;
  final bool showShadow;
  final Clip? clipBehavior;
  final Gradient? gradient;
  final Color surfaceTintColor;
  final Color shadowColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ?? (isDark ? _defaultDarkGradient() : _defaultLightGradient()),
        border: border,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: shadowColor.withOpacity(isDark ? 0.3 : 0.1),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        type: MaterialType.card,
        color: gradient != null ? null : (color ?? theme.cardColor),
        surfaceTintColor: surfaceTintColor,
        elevation: elevation,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          hoverColor: theme.colorScheme.primary.withOpacity(0.03),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: borderSide != null
                  ? Border.fromBorderSide(borderSide!)
                  : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Creates a card with a header
  static Widget withHeader({
    required Widget header,
    required Widget child,
    Key? key,
    VoidCallback? onTap,
    Color? color,
    double? width,
    double? height,
    double elevation = 1.0,
    double borderRadius = 12.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderSide? borderSide,
    bool showShadow = true,
    Clip? clipBehavior,
  }) => AppCard(
        key: key,
        onTap: onTap,
        color: color,
        width: width,
        height: height,
        elevation: elevation,
        borderRadius: borderRadius,
        margin: margin,
        borderSide: borderSide,
        showShadow: showShadow,
        clipBehavior: clipBehavior,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            const SizedBox(height: 12.0),
            child,
          ],
        ),
      );

  static Gradient _defaultLightGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.grey.shade50],
      stops: const [0.0, 1.0],
    );
  }

  static Gradient _defaultDarkGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.grey.shade900, Colors.grey.shade800],
      stops: const [0.0, 1.0],
    );
  }

  /// Creates a card with a title and optional subtitle
  static AppCard withTitle({
    required String title,
    required Widget child,
    Key? key,
    String? subtitle,
    VoidCallback? onTap,
    Color? color,
    double? width,
    double? height,
    double elevation = 4.0,
    double borderRadius = 20.0,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderSide? borderSide,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    Widget? trailing,
    EdgeInsetsGeometry? titlePadding,
    bool showDivider = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    bool showGradient = true,
    List<Color>? gradientColors,
  }) => AppCard(
      key: key,
      onTap: onTap,
      color: color,
      width: width,
      height: height,
      elevation: elevation,
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.all(0),
      margin: margin,
      borderSide: borderSide,
      gradient: showGradient
          ? (gradientColors != null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                  stops: const [0.0, 1.0],
                )
              : null)
          : null,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          
          return Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: titlePadding ?? const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: crossAxisAlignment,
                        children: [
                          Text(
                            title,
                            style: titleStyle ??
                                theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.grey.shade900,
                                  letterSpacing: -0.2,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: subtitleStyle ??
                                  theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    fontWeight: FontWeight.w400,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 12),
                      trailing,
                    ],
                  ],
                ),
              ),
              if (showDivider && child is! SizedBox)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                ),
              if (child is! SizedBox)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: child,
                )
              else
                child,
            ],
          );
        },
      ),
    );
}
