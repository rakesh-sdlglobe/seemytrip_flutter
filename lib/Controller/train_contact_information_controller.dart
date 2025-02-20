import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainContactInformationController extends GetxController {
  // Observable variables
  final RxString username = ''.obs;
  final RxBool isUsernameValid = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  // Username validation rules
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

  // API endpoint
  static const String baseUrl = 'http://192.168.1.108:3002';

  // Validate username
  void validateUsername(String value) {
    username.value = value;
    successMessage.value = '';

    if (value.isEmpty) {
      errorMessage.value = 'Username is required';
      isUsernameValid.value = false;
      return;
    }

    if (value.length < minUsernameLength) {
      errorMessage.value =
          'Username must be at least $minUsernameLength characters';
      isUsernameValid.value = false;
      return;
    }

    if (value.length > maxUsernameLength) {
      errorMessage.value =
          'Username cannot exceed $maxUsernameLength characters';
      isUsernameValid.value = false;
      return;
    }

    if (!usernameRegex.hasMatch(value)) {
      errorMessage.value =
          'Username can only contain letters, numbers, and underscores';
      isUsernameValid.value = false;
      return;
    }

    errorMessage.value = '';
    isUsernameValid.value = true;
  }

  // Clear form
  void clearForm() {
    username.value = '';
    isUsernameValid.value = false;
    errorMessage.value = '';
    successMessage.value = '';
  }

  // Verify IRCTC username
  Future<bool> verifyIRCTCUsername() async {
    if (!isUsernameValid.value) {
      return false;
    }

    try {
      isLoading.value = true;
      successMessage.value = '';

      final response = await http
          .get(
        Uri.parse('$baseUrl/api/trains/getUsernameFromIRCTC/${username.value}'),
      )
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] != null) {
          successMessage.value = 'IRCTC ID Verified';
          errorMessage.value = '';
          return true;
        } else {
          errorMessage.value = data['message'] ?? 'Invalid IRCTC username';
          successMessage.value = '';
          return false;
        }
      } else {
        errorMessage.value =
            'Failed to verify IRCTC username. Please try again.';
        successMessage.value = '';
        return false;
      }
    } catch (e) {
      errorMessage.value =
          'Error connecting to server. Please check your internet connection and try again.';
      successMessage.value = '';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Submit form
  Future<bool> submitForm() async {
    if (!isUsernameValid.value) {
      return false;
    }

    return await verifyIRCTCUsername();
  }
}
