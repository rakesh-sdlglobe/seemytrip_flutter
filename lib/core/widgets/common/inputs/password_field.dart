import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_text_field.dart';

/// A password field with toggle visibility
class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool enabled;
  final String? errorText;
  final String? helperText;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final String? initialValue;

  const PasswordField({
    Key? key,
    this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autoFocus = false,
    this.enabled = true,
    this.errorText,
    this.helperText,
    this.fillColor,
    this.filled = true,
    this.contentPadding,
    this.initialValue,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      initialValue: widget.initialValue,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      obscureText: _obscureText,
      autoFocus: widget.autoFocus,
      enabled: widget.enabled,
      errorText: widget.errorText,
      helperText: widget.helperText,
      fillColor: widget.fillColor,
      filled: widget.filled,
      contentPadding: widget.contentPadding,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).hintColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
