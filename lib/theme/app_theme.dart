// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:seemytrip/utils/colors.dart';
// import 'package:seemytrip/utils/styles.dart';

// class ThemeService extends GetxService {
//   final _box = GetStorage();
//   final _key = 'isDarkMode';

//   // Get the theme mode from local storage
//   ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
//   bool get isDarkMode => _loadThemeFromBox();

//   // Load theme from local storage
//   bool _loadThemeFromBox() => _box.read(_key) ?? false;
  
//   // Save theme to local storage
//   _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

//   // Switch theme and save to local storage
//   void switchTheme() {
//     Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
//     _saveThemeToBox(!_loadThemeFromBox());
//   }

//   // Initialize theme
//   Future<ThemeService> init() async {
//     await GetStorage.init();
//     return this;
//   }
// }

// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.light,
//       primaryColor: AppColors.primary,
//       colorScheme: ColorScheme.light(
//         primary: AppColors.primary,
//         secondary: AppColors.secondary,
//         surface: AppColors.surface,
//         background: AppColors.background,
//         error: AppColors.error,
//         onPrimary: AppColors.onPrimary,
//         onSecondary: AppColors.onSecondary,
//         onSurface: AppColors.onSurface,
//         onBackground: AppColors.onBackground,
//         onError: AppColors.onError,
//       ),
//       scaffoldBackgroundColor: AppColors.background,
//       appBarTheme: AppBarTheme(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: AppColors.background,
//         titleTextStyle: AppStyles.titleLarge.copyWith(
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//         iconTheme: const IconThemeData(color: AppColors.textPrimary),
//       ),
//       cardTheme: CardThemeData(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           side: BorderSide(color: Colors.grey.shade200),
//         ),
//         color: AppColors.surface,
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.grey.shade50,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: AppColors.error),
//         ),
//         labelStyle: AppStyles.bodyMedium.copyWith(
//           color: AppColors.textSecondary,
//         ),
//         hintStyle: AppStyles.bodyMedium.copyWith(
//           color: Colors.grey.shade500,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           textStyle: AppStyles.labelLarge.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//           elevation: 0,
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           side: const BorderSide(color: AppColors.primary),
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           textStyle: AppStyles.labelLarge.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: AppColors.primary,
//           textStyle: AppStyles.labelLarge.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       tabBarTheme: TabBarThemeData(
//         labelColor: AppColors.primary,
//         unselectedLabelColor: AppColors.textSecondary,
//         labelStyle: AppStyles.labelLarge,
//         unselectedLabelStyle: AppStyles.labelMedium,
//         indicator: UnderlineTabIndicator(
//           borderSide: BorderSide(width: 2.0, color: AppColors.primary),
//         ),
//         indicatorSize: TabBarIndicatorSize.label,
//         labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       ),
//       dividerTheme: DividerThemeData(
//         color: Colors.grey.shade200,
//         thickness: 1,
//         space: 1,
//       ),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: Colors.white,
//         selectedItemColor: AppColors.primary,
//         unselectedItemColor: Colors.grey.shade600,
//         type: BottomNavigationBarType.fixed,
//         elevation: 0,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         selectedLabelStyle: AppStyles.labelSmall,
//         unselectedLabelStyle: AppStyles.labelSmall,
//       ),
//     );
//   }

//   static ThemeData get darkTheme {
//     return ThemeData(
//       useMaterial3: true,
//       brightness: Brightness.dark,
//       primaryColor: AppColors.primaryDark,
//       colorScheme: const ColorScheme.dark(
//         primary: AppColors.primaryLight,
//         secondary: AppColors.secondaryLight,
//         surface: Color(0xFF1E1E1E),
//         background: Color(0xFF121212),
//         error: Color(0xFFCF6679),
//         onPrimary: AppColors.onPrimary,
//         onSecondary: AppColors.onSecondary,
//         onSurface: Colors.white,
//         onBackground: Colors.white,
//         onError: AppColors.onError,
//       ),
//       scaffoldBackgroundColor: const Color(0xFF121212),
//       appBarTheme: const AppBarTheme(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Color(0xFF1E1E1E),
//         titleTextStyle: TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       cardTheme: CardThemeData(
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           side: BorderSide(color: Colors.grey.shade800),
//         ),
//         color: const Color(0xFF1E1E1E),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.grey.shade900,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey.shade800),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: Colors.grey.shade800),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: AppColors.primaryLight, width: 1.5),
//         ),
//         labelStyle: const TextStyle(color: Colors.grey),
//         hintStyle: const TextStyle(color: Colors.grey),
//       ),
//       // Match other theme properties from light theme but with dark colors
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: const Color(0xFF1E1E1E),
//         selectedItemColor: AppColors.primaryLight,
//         unselectedItemColor: Colors.grey.shade600,
//         type: BottomNavigationBarType.fixed,
//         elevation: 2,
//         showSelectedLabels: true,
//         showUnselectedLabels: true,
//         selectedLabelStyle: AppStyles.labelSmall.copyWith(color: Colors.white),
//         unselectedLabelStyle: AppStyles.labelSmall.copyWith(color: Colors.grey),
//       ),
//     );
//   }
// }

// class AppThemeConfig {
//   static const double defaultPadding = 16.0;
//   static const double defaultRadius = 12.0;
//   static const double cardRadius = 12.0;
//   static const double buttonRadius = 8.0;
//   static const double inputFieldRadius = 8.0;
  
//   // Animation durations
//   static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
//   static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  
//   // Common spacing
//   static const EdgeInsetsGeometry screenPadding = EdgeInsets.all(defaultPadding);
//   static const EdgeInsetsGeometry horizontalPadding = EdgeInsets.symmetric(horizontal: defaultPadding);
//   static const EdgeInsetsGeometry verticalPadding = EdgeInsets.symmetric(vertical: defaultPadding);
  
//   // Common border radius
//   static BorderRadius borderRadius = BorderRadius.circular(defaultRadius);
//   static BorderRadius cardBorderRadius = BorderRadius.circular(cardRadius);
//   static BorderRadius buttonBorderRadius = BorderRadius.circular(buttonRadius);
//   static BorderRadius inputBorderRadius = BorderRadius.circular(inputFieldRadius);
  
//   // Common box shadows
//   static List<BoxShadow> get cardShadow => [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10,
//           offset: const Offset(0, 2),
//         ),
//       ];
      
//   static List<BoxShadow> get buttonShadow => [
//         BoxShadow(
//           color: AppColors.primary.withOpacity(0.2),
//           blurRadius: 8,
//           offset: const Offset(0, 2),
//         ),
//       ];
// }

// // Extension methods for easy access to theme properties
// extension ThemeExtension on BuildContext {
//   ThemeData get theme => Theme.of(this);
//   TextTheme get textTheme => Theme.of(this).textTheme;
//   ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
//   // Common colors
//   Color get primaryColor => theme.primaryColor;
//   Color get backgroundColor => theme.scaffoldBackgroundColor;
//   Color get cardColor => theme.cardColor;
//   Color get errorColor => theme.colorScheme.error;
  
//   // Text styles
//   TextStyle? get displayLarge => textTheme.displayLarge;
//   TextStyle? get displayMedium => textTheme.displayMedium;
//   TextStyle? get displaySmall => textTheme.displaySmall;
//   TextStyle? get headlineMedium => textTheme.headlineMedium;
//   TextStyle? get headlineSmall => textTheme.headlineSmall;
//   TextStyle? get titleLarge => textTheme.titleLarge;
//   TextStyle? get titleMedium => textTheme.titleMedium;
//   TextStyle? get titleSmall => textTheme.titleSmall;
//   TextStyle? get bodyLarge => textTheme.bodyLarge;
//   TextStyle? get bodyMedium => textTheme.bodyMedium;
//   TextStyle? get bodySmall => textTheme.bodySmall;
//   TextStyle? get labelLarge => textTheme.labelLarge;
//   TextStyle? get labelMedium => textTheme.labelMedium;
//   TextStyle? get labelSmall => textTheme.labelSmall;
  
//   // Spacing
//   double get defaultPadding => AppThemeConfig.defaultPadding;
//   EdgeInsetsGeometry get screenPadding => AppThemeConfig.screenPadding;
//   EdgeInsetsGeometry get horizontalPadding => AppThemeConfig.horizontalPadding;
//   EdgeInsetsGeometry get verticalPadding => AppThemeConfig.verticalPadding;
  
//   // Border radius
//   BorderRadius get defaultBorderRadius => AppThemeConfig.borderRadius;
//   BorderRadius get cardBorderRadius => AppThemeConfig.cardBorderRadius;
//   BorderRadius get buttonBorderRadius => AppThemeConfig.buttonBorderRadius;
//   BorderRadius get inputBorderRadius => AppThemeConfig.inputBorderRadius;
  
//   // Shadows
//   List<BoxShadow> get cardShadow => AppThemeConfig.cardShadow;
//   List<BoxShadow> get buttonShadow => AppThemeConfig.buttonShadow;
  
//   // Animations
//   Duration get defaultAnimationDuration => AppThemeConfig.defaultAnimationDuration;
//   Duration get fastAnimationDuration => AppThemeConfig.fastAnimationDuration;
// }
