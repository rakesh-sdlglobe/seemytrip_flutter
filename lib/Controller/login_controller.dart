import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seemytrip/Screens/AuthScreens/login_screen.dart';
import 'package:seemytrip/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // Observables for managing UI states
  var isTextEmpty = false.obs;
  var isSigningIn = false.obs; // To show loading state
  var userData = {}.obs;

  var isLogin = true.obs;
  var isLoading = false.obs;

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final String loginApiUrl = 'http://192.168.137.150:3002/api/login';
  final String signUpApiUrl = 'http://192.168.137.150:3002/api/signup';
  final String userProfileUrl =
      'http://192.168.137.150:3002/api/users/userProfile';

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
      Get.snackbar("Sign In", "Google Sign-In was canceled.");
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
    final user = _auth.currentUser;
    final userData = {
      "name": user?.displayName,
      "email": user?.email,
      "photoUrl": user?.photoURL,
      "uid": user?.uid,
      "phoneNumber": user?.phoneNumber,
      "creationTime": user?.metadata.creationTime?.toIso8601String(),
      "lastSignInTime": user?.metadata.lastSignInTime?.toIso8601String(),
      "isEmailVerified": user?.emailVerified ?? false,
    };

    // Step 4: Send user data to your backend
    final response = await http.post(
        Uri.parse('http://192.168.137.150:3002/api/auth/googleUserData'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    // Step 5: Handle backend response
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['token'] != null) {
        final token = responseData['token'];

        // Step 6: Save token securely
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', token);

        print('✅ Access Token Saved: $token');
        Get.snackbar("Success", "Signed in as ${user?.displayName}");
        Get.offAll(() => NavigationScreen()); // Go to main app screen
      } else {
        Get.snackbar("Error", "No token received from server.");
        print("❌ Token not found in backend response");
      }
    } else {
      print('❌ Failed to send user data: ${response.body}');
      Get.snackbar("Error", "Failed to sign in. ${response.body}");
    }
  } catch (e) {
    print("🚨 Sign-in error: $e");
    Get.snackbar("Error", "Google Sign-In failed: $e");
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
    print("Login User: $email, $password");

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(loginApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', responseData['token']);

          Get.snackbar("Success", "Login successful!");
          Get.to(() => NavigationScreen());
        } else {
          Get.snackbar("Error", "Invalid credentials");
        }
      } else {
        // Try to parse error message from response
        Map<String, dynamic>? errorResponse;
        try {
          errorResponse = json.decode(response.body);
        } catch (e) {
          // If parsing fails, ignore
        }
        
        String errorMessage = errorResponse?['message'] ?? 
                            errorResponse?['error'] ?? 
                            'Failed to login. Please try again.';
        Get.snackbar("Error", errorMessage);
      }
    } catch (error) {
      print('Error details: $error');
      Get.snackbar("Error", "An error occurred: $error");
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
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;

    // Split the full name into parts
    List<String> nameParts = name.trim().split(' ');
    String firstName = nameParts[0];
    String middleName = nameParts.length > 2 ? nameParts[1] : '';
    String lastName = nameParts.length > 2 
        ? nameParts.sublist(2).join(' ') 
        : (nameParts.length == 2 ? nameParts[1] : '');

    final Map<String, dynamic> data = {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(signUpApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Sign-up successful! Please log in.");
        toggleForm();
      } else {
        // Try to parse error message from response
        Map<String, dynamic>? errorResponse;
        try {
          errorResponse = json.decode(response.body);
        } catch (e) {
          // If parsing fails, ignore
        }
        
        String errorMessage = errorResponse?['message'] ?? 
                            errorResponse?['error'] ?? 
                            'Failed to sign up. Please try again.';
        Get.snackbar("Error", errorMessage);
      }
    } catch (error) {
      print('Error details: $error');
      Get.snackbar("Error", "An error occurred: $error");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      // Clear user data
      userData.clear();
      
      // Clear access token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      
      // Sign out from Firebase if using it
      await _auth.signOut();
      await _googleSignIn.signOut();

      // Navigate to login screen and clear all previous routes
      Get.to(() => LogInScreen());
      
      Get.snackbar(
        "Success", 
        "Logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      print("Logout error: $error");
      Get.snackbar(
        "Error",
        "Failed to logout: $error",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
