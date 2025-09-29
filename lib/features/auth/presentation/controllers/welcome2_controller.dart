import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../shared/presentation/controllers/language_controller.dart';

class Welcome2Controller extends GetxController{
  // ignore: prefer_typing_uninitialized_variables
  var selectedIndex = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeSelectedLanguage();
  }

  void _initializeSelectedLanguage() {
    final languageController = Get.find<LanguageController>();
    final currentLocale = languageController.currentLocale.value;
    final languageList = languageController.getLanguageList();
    
    // Find the index of the current language
    for (int i = 0; i < languageList.length; i++) {
      final languageData = languageList[i].value;
      final locale = languageData['locale'] as Locale;
      if (locale.languageCode == currentLocale.languageCode) {
        selectedIndex = i;
        break;
      }
    }
  }

  onIndexChange(index){
    selectedIndex=index;
    update();
  }
}