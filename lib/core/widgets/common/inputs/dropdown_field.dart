import 'package:flutter/material.dart';

/// A dropdown form field with consistent styling
class DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? labelText;
  final String? hintText;
  final String? Function(T?)? validator;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool filled;
  final Widget? prefixIcon;
  final String? helperText;
  final String? errorText;
  final bool isExpanded;
  final bool isDense;
  final Widget? icon;
  final double? iconSize;
  final bool isRequired;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;

  const DropdownField({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.validator,
    this.enabled = true,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.prefixIcon,
    this.helperText,
    this.errorText,
    this.isExpanded = false,
    this.isDense = false,
    this.icon,
    this.iconSize,
    this.isRequired = false,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: isExpanded,
      isDense: isDense,
      icon: icon ?? const Icon(Icons.arrow_drop_down),
      iconSize: iconSize ?? 24.0,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: enabled ? null : theme.disabledColor,
      ),
      decoration: InputDecoration(
        labelText: isRequired && labelText != null ? '$labelText *' : labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        filled: filled,
        fillColor: fillColor ?? theme.cardColor,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        prefixIcon: prefixIcon,
        border: border ?? _buildBorder(theme),
        enabledBorder: enabledBorder ?? _buildBorder(theme),
        focusedBorder: focusedBorder ?? _buildBorder(theme, color: colorScheme.primary),
        errorBorder: errorBorder ?? _buildBorder(theme, color: theme.colorScheme.error),
        focusedErrorBorder: focusedErrorBorder ?? _buildBorder(theme, color: theme.colorScheme.error),
        disabledBorder: disabledBorder ?? _buildBorder(theme, color: theme.disabledColor),
      ),
      dropdownColor: theme.cardColor,
      borderRadius: BorderRadius.circular(12.0),
      menuMaxHeight: 300,
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.value?.toString() ?? '',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: enabled ? null : theme.disabledColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
    );
  }

  InputBorder _buildBorder(ThemeData theme, {Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: color ?? theme.dividerColor,
        width: 1.0,
      ),
    );
  }
}

/// A helper widget to create a list of dropdown menu items from a list of values
class DropdownItems<T> {
  /// Creates dropdown menu items from a list of values
  static List<DropdownMenuItem<T>> fromList<T>({
    required List<T> items,
    required String Function(T) displayText,
    T? selectedValue,
    Widget? Function(T, bool)? itemBuilder,
    bool showDivider = false,
  }) {
    return items.map<DropdownMenuItem<T>>((T value) {
      final isSelected = value == selectedValue;
      
      return DropdownMenuItem<T>(
        value: value,
        enabled: true,
        child: itemBuilder != null
            ? itemBuilder(value, isSelected) ?? _DefaultDropdownItem(
                text: displayText(value),
                isSelected: isSelected,
              )
            : _DefaultDropdownItem(
                text: displayText(value),
                isSelected: isSelected,
              ),
      );
    }).toList();
  }
}

class _DefaultDropdownItem<T> extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _DefaultDropdownItem({
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isSelected ? theme.primaryColor : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
