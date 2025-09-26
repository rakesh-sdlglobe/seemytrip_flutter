import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:seemytrip/core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double borderRadius;
  final double height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disabledColor;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final bool isFullWidth;
  final Gradient? gradient;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.borderRadius = 12.0,
    this.height = 56.0,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.prefixIcon,
    this.padding,
    this.elevation = 0,
    this.isFullWidth = true,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isFullWidth ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        gradient: isEnabled 
            ? (gradient ?? LinearGradient(
                colors: [
                  const Color(0xFFD32F2F),
                  const Color(0xFFFF5252).withOpacity(0.9),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ))
            : null,
        color: isEnabled ? null : (disabledColor ?? Colors.grey[300]),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isEnabled && elevation > 0
            ? [
                BoxShadow(
                  color: const Color(0xFFFF5252).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isEnabled && !isLoading ? onPressed : null,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ?  SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: Colors.white,
                        size: 40,
                      )
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (prefixIcon != null) ...[
                          prefixIcon!,
                          const SizedBox(width: 10),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isEnabled
                                ? (textColor ?? Colors.white)
                                : Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // Factory constructor for primary button
  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    double borderRadius = 12.0,
    double height = 56.0,
    double? width,
    Color? backgroundColor,
    Color? textColor,
    Widget? prefixIcon,
    bool isFullWidth = true,
  }) => AppButton(
      text: text,
      onPressed: onPressed ?? () {},
      isLoading: isLoading,
      isEnabled: isEnabled,
      borderRadius: borderRadius,
      height: height,
      width: width,
      backgroundColor: backgroundColor ?? const Color(0xFFD32F2F),
      textColor: textColor ?? Colors.white,
      prefixIcon: prefixIcon,
      isFullWidth: isFullWidth,
      gradient: LinearGradient(
        colors: [
          const Color(0xFFD32F2F),
          const Color(0xFFFF5252).withOpacity(0.9),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    );
}
