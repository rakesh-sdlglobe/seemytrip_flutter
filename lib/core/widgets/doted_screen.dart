import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MyDotSeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MyDotSeparator({this.height = 1, this.color = AppColors.greyBAB});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double boxWidth = constraints.constrainWidth();
        final double dashWidth = 5.0;
        final double dashHeight = height;
        final int dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (_) => SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              ),
          ),
        );
      },
    );
}
