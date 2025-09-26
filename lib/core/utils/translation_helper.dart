import 'package:get/get.dart';

class TranslationHelper {
  // Common UI strings
  static String get welcome => 'welcome'.tr;
  static String get login => 'login'.tr;
  static String get logout => 'logout'.tr;
  static String get register => 'register'.tr;
  static String get email => 'email'.tr;
  static String get password => 'password'.tr;
  static String get confirmPassword => 'confirmPassword'.tr;
  static String get forgotPassword => 'forgotPassword'.tr;
  static String get submit => 'submit'.tr;
  static String get cancel => 'cancel'.tr;
  static String get save => 'save'.tr;
  static String get delete => 'delete'.tr;
  static String get edit => 'edit'.tr;
  static String get search => 'search'.tr;
  static String get filter => 'filter'.tr;
  static String get sort => 'sort'.tr;
  static String get loading => 'loading'.tr;
  static String get error => 'error'.tr;
  static String get success => 'success'.tr;
  static String get retry => 'retry'.tr;
  static String get noData => 'noData'.tr;
  static String get noInternet => 'noInternet'.tr;
  
  // Travel specific strings
  static String get flight => 'flight'.tr;
  static String get hotel => 'hotel'.tr;
  static String get train => 'train'.tr;
  static String get bus => 'bus'.tr;
  static String get cab => 'cab'.tr;
  static String get booking => 'booking'.tr;
  static String get bookNow => 'bookNow'.tr;
  static String get checkIn => 'checkIn'.tr;
  static String get checkOut => 'checkOut'.tr;
  static String get departure => 'departure'.tr;
  static String get arrival => 'arrival'.tr;
  static String get passengers => 'passengers'.tr;
  static String get adults => 'adults'.tr;
  static String get children => 'children'.tr;
  static String get infants => 'infants'.tr;
  static String get rooms => 'rooms'.tr;
  static String get guests => 'guests'.tr;
  static String get price => 'price'.tr;
  static String get totalPrice => 'totalPrice'.tr;
  static String get discount => 'discount'.tr;
  static String get offers => 'offers'.tr;
  static String get deals => 'deals'.tr;
  
  // Navigation strings
  static String get home => 'home'.tr;
  static String get profile => 'profile'.tr;
  static String get settings => 'settings'.tr;
  static String get help => 'help'.tr;
  static String get about => 'about'.tr;
  static String get contactUs => 'contactUs'.tr;
  static String get privacyPolicy => 'privacyPolicy'.tr;
  static String get termsOfService => 'termsOfService'.tr;
  
  // Date and time strings
  static String get today => 'today'.tr;
  static String get tomorrow => 'tomorrow'.tr;
  static String get yesterday => 'yesterday'.tr;
  static String get selectDate => 'selectDate'.tr;
  static String get selectTime => 'selectTime'.tr;
  
  // Status strings
  static String get confirmed => 'confirmed'.tr;
  static String get pending => 'pending'.tr;
  static String get cancelled => 'cancelled'.tr;
  static String get completed => 'completed'.tr;
  
  // Helper method to get translation with fallback
  static String getTranslation(String key, {String fallback = ''}) {
    try {
      return key.tr;
    } catch (e) {
      return fallback.isNotEmpty ? fallback : key;
    }
  }
  
  // Helper method to get pluralized translation
  static String getPlural(String key, int count) {
    if (count == 1) {
      return '${key}_singular'.tr;
    } else {
      return '${key}_plural'.tr;
    }
  }
  
  // Helper method to format currency based on locale
  static String formatCurrency(double amount, {String currency = 'INR'}) {
    // You can expand this to handle different locales
    return '₹${amount.toStringAsFixed(2)}';
  }
}
