import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class CommonButtonWidget {
  static Widget button({
    VoidCallback? onTap,
    String? text,
    Color? buttonColor,
    Widget? child,
  }) {
    return MaterialButton(
      onPressed: onTap,
      height: 50,
      minWidth: Get.width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: buttonColor,
      child: child ?? CommonTextWidget.PoppinsSemiBold(
        fontSize: 16,
        text: text ?? '',
        color: Colors.white,
      ),
    );
  }
}
