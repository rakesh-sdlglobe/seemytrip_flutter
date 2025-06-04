import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class CommonContainerWidget {
  static container({text, borderColor, textColor, width}) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: grey515.withOpacity(0.25),
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
