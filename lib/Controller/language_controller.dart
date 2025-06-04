import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  void onLanguageSelected(Locale locale) {
    Get.updateLocale(locale);
    update();
  }
}