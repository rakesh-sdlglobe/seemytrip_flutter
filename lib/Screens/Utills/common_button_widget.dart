import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';

class CommonButtonWidget {
  static button({onTap, text, buttonColor}) {
    return MaterialButton(
      onPressed: onTap,
      height: 50,
      minWidth: Get.width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: buttonColor,
      child: CommonTextWidget.PoppinsSemiBold(
        fontSize: 16,
        text: text,
        color: white,
      ),
    );
  }
}
