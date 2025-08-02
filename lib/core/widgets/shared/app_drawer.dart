import 'package:flutter/material.dart';

/// A drawer item model for the [AppDrawer]
class DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget? trailing;
  final Color? color;
  final double iconSize;
  final double? iconSpacing;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
  final TextStyle? textStyle;
  final double? borderRadius;
  final Color? selectedColor;
  final Color? selectedTileColor;
  final Color? unselectedTileColor;

  const DrawerItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.isSelected = false,
    this.trailing,
    this.color,
    this.iconSize = 24.0,
    this.iconSpacing,
    this.padding,
    this.showDivider = false,
    this.textStyle,
    this.borderRadius,
    this.selectedColor,
    this.selectedTileColor,
    this.unselectedTileColor,
  });

  /// Creates a divider item
  const DrawerItem.divider()
      : title = '',
        icon = Icons.horizontal_rule,
        onTap = null,
        isSelected = false,
        trailing = null,
        color = null,
        iconSize = 0,
        showDivider = true,
        textStyle = null,
        borderRadius = null,
        selectedColor = null,
        selectedTileColor = null,
        unselectedTileColor = null,
        iconSpacing = 0,
        padding = null;
}

/// A customizable drawer widget
class AppDrawer extends StatelessWidget {
  final List<DrawerItem> items;
  final Widget? header;
  final Widget? footer;
  final Color? backgroundColor;
  final double? width;
  final double elevation;
  final bool showHeaderDivider;
  final bool showFooterDivider;
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? footerPadding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTileColor;
  final Color? unselectedTileColor;
  final double? borderRadius;
  final double iconSize;
  final double iconSpacing;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final EdgeInsetsGeometry? itemPadding;
  final bool showSelectedIndicator;
  final Color? indicatorColor;
  final double indicatorWidth;
  final double indicatorHeight;
  final double indicatorRadius;
  final double indicatorPadding;

  const AppDrawer({
    Key? key,
    required this.items,
    this.header,
    this.footer,
    this.backgroundColor,
    this.width,
    this.elevation = 16.0,
    this.showHeaderDivider = true,
    this.showFooterDivider = true,
    this.headerPadding,
    this.footerPadding,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTileColor,
    this.unselectedTileColor,
    this.borderRadius,
    this.iconSize = 24.0,
    this.iconSpacing = 16.0,
    this.textStyle,
    this.selectedTextStyle,
    this.itemPadding,
    this.showSelectedIndicator = true,
    this.indicatorColor,
    this.indicatorWidth = 4.0,
    this.indicatorHeight = 24.0,
    this.indicatorRadius = 4.0,
    this.indicatorPadding = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Drawer(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null) ..._buildHeader(context),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: items.length,
              separatorBuilder: (context, index) {
                if (index < items.length - 1 && items[index + 1].showDivider) {
                  return const Divider(height: 1, thickness: 1);
                }
                return const SizedBox.shrink();
              },
              itemBuilder: (context, index) {
                final item = items[index];
                
                if (item.showDivider) {
                  return const Divider(height: 1, thickness: 1);
                }
                
                final isSelected = item.isSelected;
                final tileColor = isSelected
                    ? (selectedTileColor ?? colorScheme.primary.withOpacity(0.1))
                    : (unselectedTileColor ?? Colors.transparent);
                
                final textColor = isSelected
                    ? (selectedColor ?? colorScheme.primary)
                    : (unselectedColor ?? textTheme.bodyLarge?.color);
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: tileColor,
                    borderRadius: BorderRadius.circular(
                      item.borderRadius ?? borderRadius ?? 8.0,
                    ),
                  ),
                  child: ListTile(
                    onTap: item.onTap,
                    leading: Icon(
                      item.icon,
                      size: item.iconSize,
                      color: item.color ?? (isSelected 
                          ? (selectedColor ?? colorScheme.primary)
                          : (unselectedColor ?? textTheme.bodyLarge?.color)),
                    ),
                    title: Text(
                      item.title,
                      style: (isSelected 
                          ? (selectedTextStyle ?? textTheme.bodyLarge?.copyWith(
                              color: selectedColor ?? colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ))
                          : (item.textStyle ?? textStyle ?? textTheme.bodyLarge)),
                    ),
                    trailing: item.trailing,
                    contentPadding: item.padding ?? itemPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
                    minLeadingWidth: 0,
                    dense: true,
                    visualDensity: const VisualDensity(vertical: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        item.borderRadius ?? borderRadius ?? 8.0,
                      ),
                    ),
                    selected: isSelected,
                  ),
                );
              },
            ),
          ),
          if (footer != null) ..._buildFooter(context),
        ],
      ),
    );
  }

  List<Widget> _buildHeader(BuildContext context) {
    return [
      Padding(
        padding: headerPadding ??
            const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 24.0,
              bottom: 8.0,
            ),
        child: header,
      ),
      if (showHeaderDivider) const Divider(height: 1, thickness: 1),
    ];
  }

  List<Widget> _buildFooter(BuildContext context) {
    return [
      if (showFooterDivider) const Divider(height: 1, thickness: 1),
      Padding(
        padding: footerPadding ??
            const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 24.0,
            ),
        child: footer,
      ),
    ];
  }
}
