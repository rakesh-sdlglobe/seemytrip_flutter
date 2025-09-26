import 'package:flutter/material.dart';
import '../widgets/common_text_widget.dart';
import 'package:seemytrip/core/theme/app_colors.dart';

class CommonContainerWidget {
  static container({text, borderColor, textColor, width}) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey515.withValues(alpha: 0.25),
            offset: Offset(0, 1),
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: CommonTextWidget.PoppinsRegular(
            fontSize: 10.5,
            text: text,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
