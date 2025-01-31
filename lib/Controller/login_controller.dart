import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makeyourtripapp/Screens/NavigationSCreen/navigation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  // Observables for managing UI states
  var isTextEmpty = false.obs;
  var isSigningIn = false.obs; // To show loading state

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
        Uri.parse('http://192.168.1.8:3002/api/auth/googleUserData'),
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
}
