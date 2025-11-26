// ignore_for_file: always_specify_types, avoid_catches_without_on_clauses

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/presentation/screens/navigation/navigation_screen.dart';
import '../screens/login_screen.dart';

class LoginController extends GetxController {
  // Observables for managing UI states
  RxBool isTextEmpty = false.obs;
  RxBool isSigningIn = false.obs; // To show loading state
  RxMap userData = <dynamic, dynamic>{}.obs;

  RxBool isLogin = true.obs;
  RxBool isLoading = false.obs;
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
  }

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final String loginApiUrl = AppConfig.login;
  final String signUpApiUrl = AppConfig.signUp;
  final String userProfileUrl = AppConfig.userProfile;
  final String editProfileUrl = AppConfig.editProfile;

  // Firebase Auth and Google Sign-In Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle() async {
  try {
    isSigningIn(true); // Show loading indicator

    // Step 1: Start Google Sign-In
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      isSigningIn(false);
      Get.snackbar('Sign In', 'Google Sign-In was canceled.');
      return;
    }

    // Step 2: Authenticate with Firebase
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _auth.signInWithCredential(credential);

    // Step 3: Collect user data from Firebase
    final User? user = _auth.currentUser;
    final Map<String, Object?> userData = <String, Object?>{
      'name': user?.displayName,
      'email': user?.email,
      'photoUrl': user?.photoURL,
      'uid': user?.uid,
      'phoneNumber': user?.phoneNumber,
      'creationTime': user?.metadata.creationTime?.toIso8601String(),
      'lastSignInTime': user?.metadata.lastSignInTime?.toIso8601String(),
      'isEmailVerified': user?.emailVerified ?? false,
    };

    // Step 4: Send user data to your backend
    final http.Response response = await http.post(
        Uri.parse(AppConfig.googleUserData),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    // Step 5: Handle backend response
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['token'] != null) {
        final token = responseData['token'];

        // Step 6: Save token securely
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', token);

        print('✅ Access Token Saved: $token');
        Get.snackbar('Success', 'Signed in as ${user?.displayName}');
        await Get.offAll(() => NavigationScreen()); // Go to main app screen
      } else {
        Get.snackbar('Error', 'No token received from server.');
        print('❌ Token not found in backend response');
      }
    } else {
      print('❌ Failed to send user data: ${response.body}');
      Get.snackbar('Error', 'Failed to sign in. ${response.body}');
    }
  } catch (e) {
    print('🚨 Sign-in error: $e');
    Get.snackbar('Error', 'Google Sign-In failed: $e');
  } finally {
    isSigningIn(false); // Hide loading indicator
  }
}

  // Check if input text is empty
  void validateInput(String input) {
    isTextEmpty(input.trim().isEmpty);
  }

  void toggleForm() {
    isLogin.value = !isLogin.value;
  }

  Future<void> loginUser(String email, String password) async {
    print('Login User: $email, $password');

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;

    final Map<String, dynamic> data = <String, dynamic>{
      'email': email,
      'password': password,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(loginApiUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['token'] != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', responseData['token']);

          Get.snackbar('Success', 'Login successful!');
          await Get.to(() => NavigationScreen());
        } else {
          Get.snackbar('Error', 'Invalid credentials');
        }
      } else {
        // Try to parse error message from response
        Map<String, dynamic>? errorResponse;
        try {
          errorResponse = json.decode(response.body);
        } catch (e) {
          // If parsing fails, ignore
        }
        
        final String errorMessage = errorResponse?['message'] ?? 
                            errorResponse?['error'] ?? 
                            'Failed to login. Please try again.';
        Get.snackbar('Error', errorMessage);
      }
    } catch (error) {
      print('Error details: $error');
      Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpUser(String name, String email, String password,
      String confirmPassword) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    isLoading.value = true;

    // Split the full name into parts
    final List<String> nameParts = name.trim().split(' ');
    final String firstName = nameParts[0];
    final String middleName = nameParts.length > 2 ? nameParts[1] : '';
    final String lastName = nameParts.length > 2 
        ? nameParts.sublist(2).join(' ') 
        : (nameParts.length == 2 ? nameParts[1] : '');

    final Map<String, dynamic> data = <String, dynamic>{
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(signUpApiUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Sign-up successful! Please log in.');
        toggleForm();
      } else {
        // Try to parse error message from response
        Map<String, dynamic>? errorResponse;
        try {
          errorResponse = json.decode(response.body);
        } catch (e) {
          // If parsing fails, ignore
        }
        
        final String errorMessage = errorResponse?['message'] ?? 
                            errorResponse?['error'] ?? 
                            'Failed to sign up. Please try again.';
        Get.snackbar('Error', errorMessage);
      }
    } catch (error) {
      print('Error details: $error');
      Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Profile Management Methods
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken');

      if (token == null) {
        Get.snackbar('Error', 'No access token found. Please log in again.');
        return;
      }

      final http.Response response = await http.get(
        Uri.parse(userProfileUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userData.value = data;
        print('✅ User profile fetched successfully');
      } else {
        Get.snackbar('Error', 'Failed to fetch user profile.');
        print('❌ Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
      print('❌ Profile fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> profileData) async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        Get.snackbar('Error', 'Access token not found.');
        return false;
      }

      // Enhanced logging to verify data
      print('═══════════════════════════════════════════════════');
      print('📥 [CONTROLLER] Received Profile Data:');
      print('   - firstName: ${profileData['firstName'] ?? 'NOT PROVIDED'}');
      print('   - email: ${profileData['email'] ?? 'NOT PROVIDED'}');
      print('   - gender: ${profileData['gender'] ?? 'NOT PROVIDED'}');
      print('   - dob: ${profileData['dob'] ?? 'NOT PROVIDED'}');
      print('   - mobile: ${profileData['mobile'] ?? profileData['mobile'] ?? 'NOT PROVIDED'}');
      print('   - nationality: ${profileData['nationality'] ?? 'NOT PROVIDED'}');
      print('   - Total fields: ${profileData.length}');
      print('   - Full data map: $profileData');
      print('═══════════════════════════════════════════════════');

      // Validate required fields
      if (profileData['firstName'] == null || profileData['firstName'].toString().trim().isEmpty) {
        print('❌ [CONTROLLER] Validation failed: firstName is required');
        Get.snackbar('Error', 'First name is required');
        return false;
      }

      if (profileData['email'] == null || profileData['email'].toString().trim().isEmpty) {
        print('❌ [CONTROLLER] Validation failed: email is required');
        Get.snackbar('Error', 'Email is required');
        return false;
      }

      // Prepare JSON body
      final String jsonBody = jsonEncode(profileData);
      print('📤 [CONTROLLER] JSON Body being sent: $jsonBody');
      print('🌐 [CONTROLLER] API URL: ${AppConfig.editProfile}');
      
      final http.Response response = await http.post(
        Uri.parse(AppConfig.editProfile),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonBody,
      );

      print('═══════════════════════════════════════════════════');
      print('📥 [CONTROLLER] API Response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - Response Body: ${response.body}');
      print('═══════════════════════════════════════════════════');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Try to parse response to get updated user data
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print('✅ [CONTROLLER] Response parsed successfully');
          
          // The API response contains user data at root level
          // Extract user data and normalize field names
          Map<String, dynamic> updatedUserData = {};
          
          // Copy all fields from response (excluding message)
          responseData.forEach((key, value) {
            if (key != 'message') {
              updatedUserData[key] = value;
            }
          });
          
          // Field names are already correct - backend uses "mobile"
          
          // Normalize gender: convert M/F/O back to readable format for display
          if (updatedUserData.containsKey('gender')) {
            String gender = updatedUserData['gender'].toString();
            if (gender == 'M') {
              updatedUserData['gender'] = 'Male';
            } else if (gender == 'F') {
              updatedUserData['gender'] = 'Female';
            } else if (gender == 'O') {
              updatedUserData['gender'] = 'Other';
            }
          }
          
          // Update userData with response data
          userData.value = Map<String, dynamic>.from(updatedUserData);
          print('✅ [CONTROLLER] Updated userData from API response');
          print('✅ [CONTROLLER] Current userData: $userData');
        } catch (e) {
          // If response parsing fails, still update with sent data
          print('⚠️ [CONTROLLER] Could not parse response, using sent data: $e');
          userData.value = Map.from(userData)..addAll(profileData);
        }
        
        Get.snackbar('Success', 'Profile updated successfully');
        print('✅ [CONTROLLER] Profile update completed successfully');
        return true;
      } else {
        // Try to parse error message from response
        String errorMessage = 'Failed to update profile';
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          errorMessage = errorResponse['message'] ?? 
                        errorResponse['error'] ?? 
                        errorResponse['msg'] ??
                        'Server error: ${response.statusCode}';
          print('❌ [CONTROLLER] Error from server: $errorMessage');
        } catch (e) {
          errorMessage = 'Server error: ${response.statusCode}';
          print('❌ [CONTROLLER] Could not parse error response: $e');
        }
        
        Get.snackbar('Error', errorMessage);
        print('❌ [CONTROLLER] Profile update failed with status: ${response.statusCode}');
        print('❌ [CONTROLLER] Full error response: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      Get.snackbar('Error', 'Something went wrong: $e');
      print('❌ [CONTROLLER] Profile update exception: $e');
      print('❌ [CONTROLLER] Stack trace: $stackTrace');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Getter methods for easy access to user data
  String get userName => userData['firstName'] ?? '';
  String get userEmail => userData['email'] ?? '';
  String get userPhone => userData['mobile'] ?? '';
  String get userGender => userData['gender'] ?? '';
  String get userDob => userData['dob'] ?? '';
  String get userNationality => userData['nationality'] ?? '';

  Future<void> logout() async {
    try {
      // Clear user data
      userData.clear();
      
      // Clear access token from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      
      // Sign out from Firebase if using it
      await _auth.signOut();
      await _googleSignIn.signOut();

      // Navigate to login screen and clear all previous routes
      Get.to(() => LogInScreen());
      
      Get.snackbar(
        'Success', 
        'Logged out successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      print('Logout error: $error');
      Get.snackbar(
        'Error',
        'Failed to logout: $error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
