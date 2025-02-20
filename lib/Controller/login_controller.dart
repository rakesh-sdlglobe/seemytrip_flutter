import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeyourtripapp/Screens/AuthScreens/Login_bottom_sheet.dart';
import 'package:makeyourtripapp/Screens/AuthScreens/login_screen.dart';
import 'package:makeyourtripapp/Screens/NavigationSCreen/navigation_screen.dart';
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

  final String loginApiUrl = 'http://192.168.1.108:3002/api/login';
  final String signUpApiUrl = 'http://192.168.1.108:3002/api/signup';
  final String userProfileUrl =
      'http://192.168.1.108:3002/api/users/userProfile';

  // Firebase Auth and Google Sign-In Instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In Logic
  Future<void> signInWithGoogle() async {
    try {
      isSigningIn(true); // Show loading indicator
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isSigningIn(false);
        Get.snackbar("Sign In", "Google Sign-In was canceled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Collect user data
      final user = _auth.currentUser;
      final userData = {
        "name": user?.displayName,
        "email": user?.email,
        "photoUrl": user?.photoURL,
        "uid": user?.uid,
        "phoneNumber": user?.phoneNumber,
        // "providerData": user?.providerData.map((e) => e.toMap()).toList(),
        "creationTime": user?.metadata.creationTime?.toIso8601String(),
        "lastSignInTime": user?.metadata.lastSignInTime?.toIso8601String(),
      };

      // Send user data to backend
      final response = await http.post(
        Uri.parse('http://192.168.1.103:3002/api/auth/googleUserData'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        print('User data sent successfully: ${response.body}');
      } else {
        print('Failed to send user data: ${response.body}');
      }

      Get.snackbar("Success", "Signed in as ${user?.displayName}");
      Get.to(() => NavigationScreen());
    } catch (e) {
      Get.snackbar("Error", "Failed to sign in: $e");
      print("Failed to sign in: $e");
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
