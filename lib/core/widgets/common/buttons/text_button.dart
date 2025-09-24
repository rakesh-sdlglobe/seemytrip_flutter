import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A customizable text button
class TextButtonX extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final EdgeInsetsGeometry? padding;
  final Color? loadingColor;

  const TextButtonX({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.decoration,
    this.letterSpacing,
    this.padding,
    this.loadingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.primaryColor;
    
    return TextButton(
      onPressed: (isDisabled || isLoading) ? null : onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: _buildChild(context, textColor),
    );
  }

  Widget _buildChild(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: LoadingAnimationWidget.fourRotatingDots(
          color: loadingColor ?? textColor,
          size: 20,
        ),
      );
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDisabled 
                ? Theme.of(context).disabledColor 
                : textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            decoration: decoration,
            letterSpacing: letterSpacing,
          ),
    );
  }
}
