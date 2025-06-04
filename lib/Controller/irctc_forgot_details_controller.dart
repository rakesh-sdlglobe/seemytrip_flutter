import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class IRCTCForgotDetailsController extends GetxController {
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  final RxBool isEmailValid = false.obs;
  final RxBool isMobileValid = false.obs;
  final RxString email = ''.obs;
  final RxString mobile = ''.obs;
  final RxString dob = ''.obs;

  // Add new variables for IRCTC specific parameters
  final RxString userLoginId = ''.obs;
  final RxString IRCTC_req_type = ''.obs; // Updated with a default value
  final RxString otpType = 'email'.obs; // or 'mobile' based on user selection

  // API endpoint
  static const String baseUrl = 'https://tripadmin.seemytrip.com';

  // Validation patterns
  static final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  static final RegExp mobileRegex = RegExp(r'^[0-9]{10}$');

  void validateUsername(String username) {
    // Add your validation logic here
    if (username.isEmpty) {
      errorMessage.value = "Username cannot be empty";
    } else {
      errorMessage.value = "";
    }
  }

  // Validate email
  void validateEmail(String value) {
    email.value = value;
    if (value.isEmpty) {
      errorMessage.value = 'Email is required';
      isEmailValid.value = false;
      return;
    }
    if (!emailRegex.hasMatch(value)) {
      errorMessage.value = 'Please enter a valid email address';
      isEmailValid.value = false;
      return;
    }
    isEmailValid.value = true;
    errorMessage.value = '';
  }

  // Validate mobile
  void validateMobile(String value) {
    mobile.value = value;
    if (value.isEmpty) {
      errorMessage.value = 'Mobile number is required';
      isMobileValid.value = false;
      return;
    }
    if (!mobileRegex.hasMatch(value)) {
      errorMessage.value = 'Please enter a valid 10-digit mobile number';
      isMobileValid.value = false;
      return;
    }
    isMobileValid.value = true;
    errorMessage.value = '';
  }

  // Update setRequestType method
  void setRequestType(String type) {
    print('Setting request type to: $type'); // Debug log
    if (type.toLowerCase() == 'username' || type.toLowerCase() == 'password') {
      IRCTC_req_type.value = type.toLowerCase();
      print('IRCTC_req_type set to: ${IRCTC_req_type.value}'); // Debug log
      errorMessage.value = '';
    } else {
      errorMessage.value = 'Invalid request type';
    }
  }

  // Get forgot details
  Future<bool> getForgotDetails() async {
    print("===> Calling the forgot details api");
    isLoading.value = true; // Similar to fetchIRCTCForgotDetailsRequest()
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        throw Exception('Authentication token not found');
      }

      // Create request body similar to userDetails in React
      final Map<String, dynamic> requestBody = {
        'userName': userLoginId.value,
        'mobile': mobile.value,
        'IRCTC_req_type': IRCTC_req_type.value,
        'requestType': IRCTC_req_type.value,
        'otpType': otpType.value,
      };

      // Add optional fields based on request type
      if (IRCTC_req_type.value == 'username') {
        requestBody['email'] = email.value;
        requestBody['dob'] = dob.value;
      }

      print("Request body: $requestBody"); // Debug log

      final response = await http.post(
        Uri.parse('$baseUrl/api/trains/getForgotDetails'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(requestBody),
      );

      print("Response from IRCTC forgot details: ${response.body}");

      final data = json.decode(response.body);

      if (data['success'] == true) {
        print("Success response from IRCTC forgot details: $data");
        // Similar to fetchIRCTCForgotDetailsSuccess
        successMessage.value = IRCTC_req_type.value == 'password'
            ? 'Password reset OTP sent to your mobile number'
            : 'Recovery details sent to your ${otpType.value}';
        errorMessage.value = '';
        return true;
      } else {
        print("Error in forgot IRCTC details: $data");
        // Similar to fetchIRCTCForgotDetailsFailure
        errorMessage.value = data['error'] ?? 'Failed to recover details';
        successMessage.value = '';
        return false;
      }
    } catch (error) {
      print("Error in Forgot IRCTC user details: $error");
      // Similar to fetchIRCTCForgotDetailsFailure
      errorMessage.value = error.toString();
      successMessage.value = '';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    email.value = '';
    mobile.value = '';
    dob.value = '';
    isEmailValid.value = false;
    isMobileValid.value = false;
    errorMessage.value = '';
    successMessage.value = '';
  }

  // Submit form
  Future<bool> submitForm() async {
    errorMessage.value = '';
    
    // Validate based on request type
    if (!_validateForm()) {
      return false;
    }

    return await getForgotDetails();
  }

  // Private validation method
  bool _validateForm() {
    if (IRCTC_req_type.value == 'password') {
      if (mobile.value.isEmpty || !isMobileValid.value) {
        errorMessage.value = 'Please enter a valid mobile number';
        return false;
      }
    } else {
      if (email.value.isEmpty && mobile.value.isEmpty) {
        errorMessage.value = 'Please enter either email or mobile number';
        return false;
      }

      if (email.value.isNotEmpty && !isEmailValid.value) {
        errorMessage.value = 'Please enter a valid email address';
        return false;
      }

      if (mobile.value.isNotEmpty && !isMobileValid.value) {
        errorMessage.value = 'Please enter a valid mobile number';
        return false;
      }

      if (dob.value.isEmpty) {
        errorMessage.value = 'Please enter your date of birth';
        return false;
      }
    }
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    // Set a default request type if needed
    setRequestType('username');
  }
}