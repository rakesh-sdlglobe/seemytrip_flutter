import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// A customizable secondary button
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderWidth;
  final Color? borderColor;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = 8.0,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderWidth,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: width,
      height: height ?? 48.0,
      child: OutlinedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: textColor ?? theme.primaryColor,
          padding: padding,
          side: BorderSide(
            color: isDisabled 
                ? theme.disabledColor 
                : borderColor ?? theme.primaryColor,
            width: borderWidth ?? 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBackgroundColor: theme.disabledColor.withOpacity(0.1),
          disabledForegroundColor: theme.disabledColor,
        ),
        child: _buildChild(context),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.black54,
          size: 24,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: textColor ?? Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: textColor ?? Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
