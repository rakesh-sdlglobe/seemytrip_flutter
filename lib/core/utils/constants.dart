/// App-wide constants that don't fit into other categories
class AppConstants {
  // App Info
  static const String appName = 'SeeMyTrip';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const String apiBaseUrl = 'https://api.seemytrip.com/v1';
  static const int apiTimeout = 30000; // 30 seconds
  
  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String localeKey = 'locale';
  static const String themeModeKey = 'theme_mode';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 64;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';
  
  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImage = 'assets/images/placeholder.jpg';
  
  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration buttonPressDuration = Duration(milliseconds: 200);
  
  // Other
  static const String unknownError = 'An unknown error occurred';
  static const String noInternet = 'No internet connection';
  static const String tryAgain = 'Please try again';
  
  // Prevent instantiation
  AppConstants._();
}
