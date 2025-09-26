import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

import '../../shared/constants/font_family.dart';

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
      cursorColor: AppColors.black2E2,
      controller: controller,
      style: TextStyle(
        color: AppColors.black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.grey929,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsMedium,
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: EdgeInsets.zero,
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.redCA0, width: 1.5),
        ),
        // ... rest of your decoration
      ),
    );
}