// import 'package:flutter/material.dart';
// import 'package:seemytrip/utils/colors.dart';
// import 'package:seemytrip/utils/styles.dart';

// class PrimaryButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isFullWidth;
//   final bool isLoading;
//   final double? height;
//   final double? width;
//   final Color? color;
//   final Color? textColor;

//   const PrimaryButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.isFullWidth = true,
//     this.isLoading = false,
//     this.height = 48,
//     this.width,
//     this.color,
//     this.textColor,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: isFullWidth ? double.infinity : width,
//       height: height,
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color ?? AppColors.primary,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           elevation: 0,
//         ),
//         child: isLoading
//             ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//             : Text(
//                 text,
//                 style: AppStyles.labelLarge.copyWith(
//                   color: textColor ?? Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//       ),
//     );
//   }
// }

// class AppTextField extends StatelessWidget {
//   final String? label;
//   final String? hintText;
//   final TextEditingController? controller;
//   final bool obscureText;
//   final TextInputType? keyboardType;
//   final String? Function(String?)? validator;
//   final Widget? prefixIcon;
//   final Widget? suffixIcon;
//   final int? maxLines;
//   final int? maxLength;
//   final bool readOnly;
//   final VoidCallback? onTap;
//   final TextInputAction? textInputAction;
//   final Function(String)? onChanged;

//   const AppTextField({
//     Key? key,
//     this.label,
//     this.hintText,
//     this.controller,
//     this.obscureText = false,
//     this.keyboardType,
//     this.validator,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.maxLines = 1,
//     this.maxLength,
//     this.readOnly = false,
//     this.onTap,
//     this.textInputAction,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null) ...{
//           Text(
//             label!,
//             style: AppStyles.labelMedium.copyWith(
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//           const SizedBox(height: 4),
//         },
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           keyboardType: keyboardType,
//           validator: validator,
//           maxLines: maxLines,
//           maxLength: maxLength,
//           readOnly: readOnly,
//           onTap: onTap,
//           textInputAction: textInputAction,
//           onChanged: onChanged,
//           style: AppStyles.bodyMedium,
//           decoration: InputDecoration(
//             hintText: hintText,
//             hintStyle: AppStyles.bodyMedium.copyWith(
//               color: Theme.of(context).hintColor,
//             ),
//             prefixIcon: prefixIcon != null
//                 ? Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: prefixIcon,
//                   )
//                 : null,
//             suffixIcon: suffixIcon,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide(
//                 color: Theme.of(context).dividerColor,
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide(
//                 color: Theme.of(context).dividerColor,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               borderSide: BorderSide(
//                 color: Theme.of(context).primaryColor,
//                 width: 1.5,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SectionHeader extends StatelessWidget {
//   final String title;
//   final String? actionText;
//   final VoidCallback? onAction;

//   const SectionHeader({
//     Key? key,
//     required this.title,
//     this.actionText,
//     this.onAction,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: AppStyles.titleLarge.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           if (actionText != null && onAction != null)
//             TextButton(
//               onPressed: onAction,
//               style: TextButton.styleFrom(
//                 padding: EdgeInsets.zero,
//                 minimumSize: const Size(0, 0),
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               ),
//               child: Text(
//                 actionText!,
//                 style: AppStyles.labelMedium.copyWith(
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class AppSpacing {
//   static const double xs = 4.0;
//   static const double sm = 8.0;
//   static const double md = 16.0;
//   static const double lg = 24.0;
//   static const double xl = 32.0;
//   static const double xxl = 48.0;

//   static const EdgeInsetsGeometry screenPadding = EdgeInsets.all(md);
//   static const EdgeInsetsGeometry horizontalPadding = EdgeInsets.symmetric(horizontal: md);
//   static const EdgeInsetsGeometry verticalPadding = EdgeInsets.symmetric(vertical: md);
// }

// extension ContextExtension on BuildContext {
//   double get screenWidth => MediaQuery.of(this).size.width;
//   double get screenHeight => MediaQuery.of(this).size.height;
  
//   bool get isSmallScreen => screenWidth < 360;
//   bool get isMediumScreen => screenWidth >= 360 && screenWidth < 414;
//   bool get isLargeScreen => screenWidth >= 414;
  
//   double responsiveWidth(double size) {
//     if (isSmallScreen) return size * 0.9;
//     if (isLargeScreen) return size * 1.1;
//     return size;
//   }
  
//   double responsiveHeight(double size) {
//     if (screenHeight < 700) return size * 0.9;
//     if (screenHeight > 800) return size * 1.1;
//     return size;
//   }
// }
