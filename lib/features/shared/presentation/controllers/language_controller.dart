import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final GetStorage _storage = GetStorage();
  static const String _languageKey = 'selected_language';
  
  // Available languages with their display names
  final Map<String, Map<String, dynamic>> availableLanguages = {
    'en': {'name': 'English', 'nativeName': 'English', 'locale': Locale('en'), 'rtl': false},
    'hi': {'name': 'Hindi', 'nativeName': 'हिन्दी', 'locale': Locale('hi'), 'rtl': false},
    'ta': {'name': 'Tamil', 'nativeName': 'தமிழ்', 'locale': Locale('ta'), 'rtl': false},
    'kn': {'name': 'Kannada', 'nativeName': 'ಕನ್ನಡ', 'locale': Locale('kn'), 'rtl': false},
    'te': {'name': 'Telugu', 'nativeName': 'తెలుగు', 'locale': Locale('te'), 'rtl': false},
    'or': {'name': 'Odia', 'nativeName': 'ଓଡ଼ିଆ', 'locale': Locale('or'), 'rtl': false},
    'fr': {'name': 'French', 'nativeName': 'Français', 'locale': Locale('fr'), 'rtl': false},
    'es': {'name': 'Spanish', 'nativeName': 'Español', 'locale': Locale('es'), 'rtl': false},
    'ar': {'name': 'Arabic', 'nativeName': 'العربية', 'locale': Locale('ar'), 'rtl': true},
    'de': {'name': 'German', 'nativeName': 'Deutsch', 'locale': Locale('de'), 'rtl': false},
    'zh': {'name': 'Chinese', 'nativeName': '中文', 'locale': Locale('zh'), 'rtl': false},
  };

  Rx<Locale> currentLocale = Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    String? savedLanguageCode = _storage.read(_languageKey);
    if (savedLanguageCode != null && availableLanguages.containsKey(savedLanguageCode)) {
      Locale savedLocale = availableLanguages[savedLanguageCode]!['locale'];
      currentLocale.value = savedLocale;
      Get.updateLocale(savedLocale);
    }
  }

  void onLanguageSelected(Locale locale) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    _storage.write(_languageKey, locale.languageCode);
    
    // Force rebuild of all GetX widgets
    Get.forceAppUpdate();
    update();
  }

  String getCurrentLanguageName() {
    String currentCode = currentLocale.value.languageCode;
    return availableLanguages[currentCode]?['nativeName'] ?? 'English';
  }

  List<MapEntry<String, Map<String, dynamic>>> getLanguageList() {
    return availableLanguages.entries.toList();
  }
  
  bool isCurrentLanguageRTL() {
    String currentCode = currentLocale.value.languageCode;
    return availableLanguages[currentCode]?['rtl'] ?? false;
  }
  
  TextDirection getTextDirection() {
    return isCurrentLanguageRTL() ? TextDirection.rtl : TextDirection.ltr;
  }
}