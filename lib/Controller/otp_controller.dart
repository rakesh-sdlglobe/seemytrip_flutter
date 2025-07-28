import 'package:get/get.dart';
import 'package:seemytrip/Screens/HomeScreen/home_screen.dart';
import 'package:seemytrip/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class OtpController extends GetxController {
  final String baseUrl = 'http://192.168.137.150:3002';
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool showOtpFields = false.obs;
  final RxBool isButtonEnabled = false.obs;
  final RxInt secondsRemaining = 300.obs;
  final RxBool isTimerRunning = false.obs;
  final RxBool canResend = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString email = ''.obs;
  
  Timer? countdownTimer;

  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  @override
  void onClose() {
    countdownTimer?.cancel();
    super.onClose();
  }

  void startTimer() {
    countdownTimer?.cancel();
    
    secondsRemaining.value = 300;
    isTimerRunning.value = true;
    canResend.value = false;

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
        isTimerRunning.value = false;
        canResend.value = true;
      }
    });
  }

  Future<bool> sendOtp(String email) async {
    try {
      print('Attempting to send OTP to: $email'); // Debug log
      
      if (email.isEmpty) {
        errorMessage.value = 'Please enter your email address';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      final Map<String, dynamic> requestBody = {
        'email': email,
      };

      print('Request body: ${json.encode(requestBody)}'); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/api/send-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out. Please try again.');
        },
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] != null) {
          showOtpFields.value = true;
          this.email.value = email;
          startTimer();
          Get.snackbar(
            'Success',
            data['success'],
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
          return true;
        }
      }
      throw Exception('Failed to send OTP');
    } catch (e) {
      print('Error sending OTP: $e'); // Debug log
      errorMessage.value = e.toString().replaceAll('Exception:', '').trim();
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (email.value.isEmpty || otp.isEmpty) {
        errorMessage.value = 'Email and OTP are required';
        return false;
      }

      print('=== OTP Verification Debug ===');
      print('Endpoint: $baseUrl/api/verify-otp');
      print('Email: ${email.value}');
      print('OTP: $otp');
      print('=============================');
      
      final requestBody = {
        'email': email.value,
        'otp': otp
      };
      
      print('Request Body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/api/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email.value,
          'otp': otp
        }),
      ).timeout(
        Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Request timed out. Please try again.');
        },
      );

      print('=== Response Debug ===');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('======================');

      if (response.statusCode == 200) {
        // First try to parse as JSON
        try {
          final data = json.decode(response.body);
          
          // Save the received token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', data['token']);
          await prefs.setString('userEmail', data['email']);
          if (data['firstName'] != null) {
            await prefs.setString('firstName', data['firstName']);
          }
        } catch (e) {
          print('Error parsing response: $e');
          throw Exception('Invalid response format from server');
        }

        countdownTimer?.cancel();
        Get.snackbar(
          'Success',
          'Email verified successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to appropriate screen after successful verification
         Get.offAll(() => NavigationScreen()); // Adjust route as needed
        return true;
      } else {
        String errorMessage = 'Failed to verify OTP. Status: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData['message'] ?? errorData.toString();
        } catch (e) {
          // If response is not JSON, use the raw response body
          errorMessage = response.body.isNotEmpty 
              ? response.body 
              : 'Server error occurred';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error verifying OTP: $e'); // Debug log
      errorMessage.value = e.toString()
          .replaceAll('Exception:', '')
          .replaceAll('TimeoutException:', '')
          .trim();
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void resetState() {
    showOtpFields.value = false;
    isTimerRunning.value = false;
    canResend.value = false;
    secondsRemaining.value = 300;
    errorMessage.value = '';
    countdownTimer?.cancel();
  }

  void updateButtonState(String otpValue) {
    isButtonEnabled.value = otpValue.length == 6;
  }
}