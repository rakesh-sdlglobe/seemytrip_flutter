import 'package:flutter/material.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';

class CommonTextWidget {
  static PoppinsBold(
      {String? text, Color? color, double? fontSize, TextAlign? textAlign, TextDecoration? textDecoration}) {
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: FontFamily.PoppinsBold,
          decoration:textDecoration,
      ),
    );
  }

  static PoppinsRegular(
      {String? text, Color? color, double? fontSize, TextAlign? textAlign,TextDecoration? textDecoration}) {
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: FontFamily.PoppinsRegular,
      ),
    );
  }

  static PoppinsSemiBold(
      {String? text, Color? color, double? fontSize, TextAlign? textAlign,TextDecoration? textDecoration}) {
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: FontFamily.PoppinsSemiBold,
      ),
    );
  }

  static PoppinsMedium(
      {String? text, Color? color, double? fontSize, TextAlign? textAlign,TextDecoration? textDecoration}) {
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: FontFamily.PoppinsMedium,
      ),
    );
  }

  static PoppinsLight(
      {String? text, Color? color, double? fontSize, TextAlign? textAlign,TextDecoration? textDecoration}) {
    return Text(
      text!,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: FontFamily.PoppinsLight,
      ),
    );
  }
}
