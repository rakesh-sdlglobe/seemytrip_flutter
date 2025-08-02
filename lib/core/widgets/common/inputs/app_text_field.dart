import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field with consistent styling
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool autoFocus;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;

  const AppTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.fillColor,
    this.filled = true,
    this.contentPadding,
    this.inputFormatters,
    this.showCounter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofocus: autoFocus,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: enabled ? null : theme.disabledColor,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        helperText: helperText,
        counterText: showCounter ? null : '',
        filled: filled,
        fillColor: fillColor ?? theme.cardColor,
        contentPadding: contentPadding ?? const EdgeInsets.all(16.0),
        border: _buildBorder(theme),
        enabledBorder: _buildBorder(theme),
        focusedBorder: _buildBorder(theme, color: colorScheme.primary),
        errorBorder: _buildBorder(theme, color: theme.colorScheme.error),
        focusedErrorBorder: _buildBorder(theme, color: theme.colorScheme.error),
        disabledBorder: _buildBorder(theme, color: theme.disabledColor),
      ),
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
