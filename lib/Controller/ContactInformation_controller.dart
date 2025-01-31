import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainAndBusContactInformationController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final RxBool isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    isButtonEnabled.value = usernameController.text.isNotEmpty;
  }

  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  void submit() {
    String username = usernameController.text;
    Get.back(result: username);
  }
}
