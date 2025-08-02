// import 'package:flutter/material.dart';

// class LayoutHelper {
//   // Screen size breakpoints
//   static const double mobileBreakpoint = 600;
//   static const double tabletBreakpoint = 900;
//   static const double desktopBreakpoint = 1200;

//   // Check device type
//   static bool isMobile(BuildContext context) =>
//       MediaQuery.of(context).size.width < mobileBreakpoint;

//   static bool isTablet(BuildContext context) =>
//       MediaQuery.of(context).size.width >= mobileBreakpoint &&
//       MediaQuery.of(context).size.width < desktopBreakpoint;

//   static bool isDesktop(BuildContext context) =>
//       MediaQuery.of(context).size.width >= desktopBreakpoint;

//   // Responsive value based on screen size
//   static T responsiveValue<T>({
//     required BuildContext context,
//     required T mobile,
//     T? tablet,
//     T? desktop,
//   }) {
//     final width = MediaQuery.of(context).size.width;
    
//     if (width >= desktopBreakpoint) {
//       return desktop ?? tablet ?? mobile;
//     } else if (width >= mobileBreakpoint) {
//       return tablet ?? mobile;
//     } else {
//       return mobile;
//     }
//   }

//   // Responsive padding
//   static EdgeInsetsGeometry responsivePadding(BuildContext context) {
//     return EdgeInsets.symmetric(
//       horizontal: responsiveValue<double>(
//         context: context,
//         mobile: 16,
//         tablet: 24,
//         desktop: 32,
//       ),
//       vertical: 12,
//     );
//   }

//   // Responsive text scale factor
//   static double textScaleFactor(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     if (width < 360) return 0.9;  // Small devices
//     if (width > 600) return 1.1;   // Tablets and larger
//     return 1.0;                    // Normal devices
//   }

//   // Responsive font size
//   static double responsiveFontSize({
//     required BuildContext context,
//     required double baseSize,
//     double? tabletSize,
//     double? desktopSize,
//   }) {
//     return responsiveValue<double>(
//       context: context,
//       mobile: baseSize,
//       tablet: tabletSize ?? baseSize * 1.1,
//       desktop: desktopSize ?? baseSize * 1.2,
//     );
//   }
// }

// // Extension methods for easy access to layout helpers
// extension LayoutExtension on BuildContext {
//   // Device type checkers
//   bool get isMobile => LayoutHelper.isMobile(this);
//   bool get isTablet => LayoutHelper.isTablet(this);
//   bool get isDesktop => LayoutHelper.isDesktop(this);

//   // Responsive value getter
//   T responsive<T>({
//     required T mobile,
//     T? tablet,
//     T? desktop,
//   }) {
//     return LayoutHelper.responsiveValue<T>(
//       context: this,
//       mobile: mobile,
//       tablet: tablet,
//       desktop: desktop,
//     );
//   }

//   // Responsive padding
//   EdgeInsetsGeometry get responsivePadding =>
//       LayoutHelper.responsivePadding(this);

//   // Responsive font size
//   double responsiveFontSize({
//     required double baseSize,
//     double? tabletSize,
//     double? desktopSize,
//   }) {
//     return LayoutHelper.responsiveFontSize(
//       context: this,
//       baseSize: baseSize,
//       tabletSize: tabletSize,
//       desktopSize: desktopSize,
//     );
//   }

//   // Screen dimensions
//   double get screenWidth => MediaQuery.of(this).size.width;
//   double get screenHeight => MediaQuery.of(this).size.height;
//   double get statusBarHeight => MediaQuery.of(this).padding.top;
//   double get bottomInset => MediaQuery.of(this).viewInsets.bottom;
//   double get safeAreaHeight =>
//       screenHeight - statusBarHeight - kToolbarHeight - bottomInset;
// }

// // Widget that applies responsive padding
// class ResponsivePadding extends StatelessWidget {
//   final Widget child;
//   final EdgeInsetsGeometry? padding;
//   final bool applyHorizontalPadding;
//   final bool applyVerticalPadding;

//   const ResponsivePadding({
//     Key? key,
//     required this.child,
//     this.padding,
//     this.applyHorizontalPadding = true,
//     this.applyVerticalPadding = true,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final defaultPadding = context.responsivePadding;
//     final horizontalPadding = applyHorizontalPadding
//         ? (padding as EdgeInsets?)?.horizontal ??
//             (defaultPadding as EdgeInsets).horizontal
//         : 0.0;
//     final verticalPadding = applyVerticalPadding
//         ? (padding as EdgeInsets?)?.vertical ??
//             (defaultPadding as EdgeInsets).vertical
//         : 0.0;

//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: horizontalPadding,
//         vertical: verticalPadding,
//       ),
//       child: child,
//     );
//   }
// }

// // Widget that changes its child based on screen size
// class ResponsiveLayout extends StatelessWidget {
//   final Widget mobile;
//   final Widget? tablet;
//   final Widget? desktop;

//   const ResponsiveLayout({
//     Key? key,
//     required this.mobile,
//     this.tablet,
//     this.desktop,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth >= LayoutHelper.desktopBreakpoint) {
//           return desktop ?? tablet ?? mobile;
//         } else if (constraints.maxWidth >= LayoutHelper.mobileBreakpoint) {
//           return tablet ?? mobile;
//         } else {
//           return mobile;
//         }
//       },
//     );
//   }
// }
