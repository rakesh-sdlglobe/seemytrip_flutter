import 'package:flutter/material.dart';
import '../../shared/constants/font_family.dart';
import 'colors.dart';

class CommonTextFieldWidget extends StatelessWidget {

  const CommonTextFieldWidget({
    Key? key,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.onChanged,
  }) : super(key: key);
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
      onChanged: onChanged,
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
          borderSide: BorderSide(color: redCA0, width: 1.5),
        ),
        // ... rest of your decoration
      ),
    );
}