// import 'package:flutter/material.dart';

// /// A collection of spacing constants used throughout the app for consistent layout.
// class AppSpacing {
//   // Spacing constants
//   static const double xs = 4.0;
//   static const double sm = 8.0;
//   static const double md = 12.0;
//   static const double lg = 16.0;
//   static const double xl = 24.0;
//   static const double xxl = 32.0;
//   static const double xxxl = 48.0;
  
//   // Border radius
//   static const double radiusSm = 4.0;
//   static const double radiusMd = 8.0;
//   static const double radiusLg = 12.0;
//   static const double radiusXl = 16.0;
//   static const double radiusXxl = 24.0;
  
//   // Elevation
//   static const double elevationSm = 2.0;
//   static const double elevationMd = 4.0;
//   static const double elevationLg = 8.0;
  
//   // Animation durations
//   static const Duration shortAnimation = Duration(milliseconds: 200);
//   static const Duration mediumAnimation = Duration(milliseconds: 300);
//   static const Duration longAnimation = Duration(milliseconds: 500);
  
//   // Responsive breakpoints
//   static const double mobileWidth = 600.0;
//   static const double tabletWidth = 900.0;
//   static const double desktopWidth = 1200.0;
  
//   /// Returns true if the current screen width is considered mobile
//   static bool isMobile(BuildContext context) => 
//       MediaQuery.of(context).size.width < mobileWidth;
      
//   /// Returns true if the current screen width is considered tablet
//   static bool isTablet(BuildContext context) => 
//       MediaQuery.of(context).size.width >= mobileWidth && 
//       MediaQuery.of(context).size.width < desktopWidth;
      
//   /// Returns true if the current screen width is considered desktop
//   static bool isDesktop(BuildContext context) => 
//       MediaQuery.of(context).size.width >= desktopWidth;
      
//   /// Returns the appropriate padding based on screen size
//   static EdgeInsets getScreenPadding(BuildContext context) {
//     if (isDesktop(context)) {
//       return const EdgeInsets.symmetric(horizontal: 48.0, vertical: 24.0);
//     } else if (isTablet(context)) {
//       return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);
//     } else {
//       return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
//     }
//   }
  
//   /// Returns appropriate icon size based on screen size
//   static double getIconSize(BuildContext context) {
//     if (isDesktop(context)) return 32.0;
//     if (isTablet(context)) return 28.0;
//     return 24.0;
//   }
// }

// /// Extension methods for adding space around widgets
// extension SpacingExtension on num {
//   /// Returns a SizedBox with height equal to the value
//   SizedBox get heightBox => SizedBox(height: toDouble());
  
//   /// Returns a SizedBox with width equal to the value
//   SizedBox get widthBox => SizedBox(width: toDouble());
  
//   /// Returns EdgeInsets with all sides equal to the value
//   EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  
//   /// Returns EdgeInsets with horizontal padding equal to the value
//   EdgeInsets get paddingHorizontal => 
//       EdgeInsets.symmetric(horizontal: toDouble());
      
//   /// Returns EdgeInsets with vertical padding equal to the value
//   EdgeInsets get paddingVertical => 
//       EdgeInsets.symmetric(vertical: toDouble());
// }

// /// Extension for responsive layout
// extension ResponsiveExtension on BuildContext {
//   /// Returns screen size
//   Size get screenSize => MediaQuery.of(this).size;
  
//   /// Returns screen width
//   double get screenWidth => screenSize.width;
  
//   /// Returns screen height
//   double get screenHeight => screenSize.height;
  
//   /// Returns true if the screen is in landscape orientation
//   bool get isLandscape => 
//       MediaQuery.of(this).orientation == Orientation.landscape;
  
//   /// Returns a percentage of the screen width
//   double widthPercent(double percent) => screenWidth * (percent / 100);
  
//   /// Returns a percentage of the screen height
//   double heightPercent(double percent) => screenHeight * (percent / 100);
// }
