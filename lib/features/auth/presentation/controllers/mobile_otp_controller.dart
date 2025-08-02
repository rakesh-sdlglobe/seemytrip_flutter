import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:seemytrip/core/presentation/screens/navigation/navigation_screen.dart';

class MobileOtpController extends GetxController {
  var isOtpSent = false.obs;
  var isLoading = false.obs;

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final String sendOtpUrl = 'https://tripadmin.onrender.com/api/send-otp';
  final String verifyOtpUrl = 'https://tripadmin.onrender.com/api/verify-otp';

  Future<void> sendOtp() async {
    if (mobileController.text.isEmpty || mobileController.text.length != 10) {
      Get.snackbar("Error", "Enter a valid 10-digit mobile number");
      return;
    }

    isLoading.value = true;
    final Map<String, dynamic> data = {'mobile': mobileController.text};

    try {
      final response = await http.post(
        Uri.parse(sendOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        isOtpSent.value = true;
        Get.snackbar("Success", "OTP sent successfully!");
      } else {
        Get.snackbar("Error", "Failed to send OTP. Try again.");
      }
    } catch (error) {
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty || otpController.text.length != 6) {
      Get.snackbar("Error", "Enter a valid 6-digit OTP");
      return;
    }

    isLoading.value = true;
    final Map<String, dynamic> data = {
      'mobile': mobileController.text,
      'otp': otpController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('accessToken', responseData['token']);
        
        Get.snackbar("Success", "OTP verified! Logging in...");
        Get.to(() => NavigationScreen());
      } else {
        Get.snackbar("Error", "Invalid OTP. Try again.");
      }
    } catch (error) {
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      isLoading.value = false;
    }
  }
}
