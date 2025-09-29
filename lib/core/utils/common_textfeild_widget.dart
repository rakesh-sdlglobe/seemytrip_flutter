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
      cursorColor: Theme.of(context).brightness == Brightness.dark 
          ? AppColors.textPrimaryDark 
          : AppColors.black2E2,
      controller: controller,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.textPrimaryDark 
            : AppColors.black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppColors.textHintDark 
              : AppColors.grey929,
          fontSize: 14,
          fontFamily: FontFamily.PoppinsMedium,
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark 
            ? AppColors.surfaceDark 
            : AppColors.white,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.borderDark 
                : AppColors.grey929,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.borderDark 
                : AppColors.grey929,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.redCA0, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.redCA0, width: 1.5),
        ),
      ),
    );
}