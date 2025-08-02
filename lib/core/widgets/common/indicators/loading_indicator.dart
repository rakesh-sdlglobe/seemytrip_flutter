import 'package:flutter/material.dart';
import 'package:seemytrip/core/widgets/common/cards/app_card.dart';

/// A customizable loading indicator
class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? message;
  final Axis direction;
  final double spacing;
  final TextStyle? messageStyle;

  const LoadingIndicator({
    Key? key,
    this.size = 24.0,
    this.strokeWidth = 2.0,
    this.color,
    this.message,
    this.direction = Axis.horizontal,
    this.spacing = 8.0,
    this.messageStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.primaryColor,
        ),
      ),
    );

    if (message == null) return indicator;

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          indicator,
          SizedBox(width: spacing),
          Text(
            message!,
            style: messageStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          indicator,
          SizedBox(height: spacing),
          Text(
            message!,
            style: messageStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
      );
    }
  }
}

/// A full screen loading overlay
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final bool showBackground;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double indicatorSize;
  final EdgeInsets padding;

  const FullScreenLoading({
    Key? key,
    this.message,
    this.showBackground = true,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorSize = 48.0,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: showBackground
          ? (backgroundColor ?? Colors.black.withOpacity(0.5))
          : Colors.transparent,
      child: Center(
        child: AppCard(
          padding: padding,
          color: showBackground ? null : Colors.transparent,
          elevation: showBackground ? 4.0 : 0.0,
          child: LoadingIndicator(
            size: indicatorSize,
            color: indicatorColor,
            message: message,
            direction: Axis.vertical,
          ),
        ),
      ),
    );
  }
}