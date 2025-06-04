import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';

class CommonTextFieldWidget {
  static TextFormField1({
    prefixIcon,
    controller,
    keyboardType,
    hintText,
    onChange,
  }) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: grey929,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsMedium,
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.zero,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: redCA0, width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: redCA0, width: 1.5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: redCA0, width: 1.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: redCA0, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: redCA0, width: 1.5)),
      ),
    );
  }

  static TextFormField2({
    prefixIcon,
    controller,
    keyboardType,
    hintText,
    onChange,
  }) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: grey717,
          fontSize: 15,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.zero,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: white, width: 0)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: white, width: 0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: white, width: 0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: white, width: 0)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: white, width: 0)),
      ),
    );
  }

  static TextFormField3({
    suffixIcon,
    controller,
    keyboardType,
    hintText,
    onChange,
  }) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: grey717,
          fontSize: 16,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.fromLTRB(0, 12, 5, 0),
        disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
      ),
    );
  }

  static TextFormField9({
    suffixIcon,
    controller,
    keyboardType,
    hintText,
    onChange,
  }) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIconConstraints: BoxConstraints(
          minWidth: 2,
          minHeight: 2,
        ),
        hintStyle: TextStyle(
          color: grey717,
          fontSize: 10,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.only(top: 23),
          child: suffixIcon,
        ),
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.fromLTRB(0, 26, 0, 0),
        disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
        errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyD4D, width: 0)),
      ),
    );
  }

  static TextFormField4({
    controller,
    keyboardType,
    hintText,
    onChange,
  }) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: grey717,
          fontSize: 16,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.only(left: 12),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
      ),
    );
  }

  static TextFormField5({
    controller,
    keyboardType,
    hintText,
    onChange,
  }) {
    return TextFormField(
      onChanged: onChange,
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: greyC2C,
          fontSize: 12,
          fontFamily: FontFamily.PoppinsMedium,
        ),
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.only(left: 12),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: grey717, width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: grey717, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: grey717, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: grey717, width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: grey717, width: 1)),
      ),
    );
  }

  static TextFormField6({
    controller,
    keyboardType,
    hintText,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: grey9B9,
          fontSize: 12,
          fontFamily: FontFamily.PoppinsMedium,
        ),
        filled: true,
        fillColor: grey9B9.withOpacity(0.15),
        contentPadding: EdgeInsets.only(left: 12),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE2E, width: 1)),
      ),
    );
  }

  static TextFormField7({
    preffixIcon,
    controller,
    keyboardType,
    hintText,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: black2E2,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        prefixIcon: preffixIcon,
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.zero,
        disabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyE8E, width: 0)),
        border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyE8E, width: 0)),
        focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyE8E, width: 0)),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyE8E, width: 0)),
        errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(0),
            borderSide: BorderSide(color: greyE8E, width: 0)),
      ),
    );
  }

  static TextFormField8({controller, keyboardType, hintText, suffixIcon}) {
    return TextFormField(
      keyboardType: keyboardType,
      cursorColor: black2E2,
      controller: controller,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: black2E2,
          fontSize: 12,
          fontFamily: FontFamily.PoppinsMedium,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: whiteF4F,
        contentPadding: EdgeInsets.only(left: 12),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE6E, width: 1)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE6E, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE6E, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE6E, width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: greyE6E, width: 1)),
      ),
    );
  }
}
