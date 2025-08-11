import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';

// Import the generated platform interface
import 'package:razorpay_flutter/razorpay_flutter.dart' show Razorpay, PaymentSuccessResponse, PaymentFailureResponse, ExternalWalletResponse;

import '../../../../core/routes/app_routes.dart';

class PaymentController extends GetxController {
  final Razorpay _razorpay = Razorpay();
  final String _baseUrl = 'http://192.168.1.8:3002/api/hotels'; // Replace with your actual API base URL
  final String _razorpayKey = 'rzp_test_8PKYstLwYTk5Qy'; // Replace with your actual Razorpay key ID from Razorpay dashboard
  final Map<String, String> _headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _razorpay..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
    ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
    ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear();
    super.onClose();
  }

  Future<void> processPayment({
    required double amount,
    required String name,
    required String email,
    required String phone,
    required Map<String, dynamic> bookingDetails,
  }) async {
    // Store booking details for confirmation screen
    
    final Map<String, dynamic> bookingArgs = {
      'amount': '₹${amount.toStringAsFixed(2)}',
      'hotelName': bookingDetails['hotelName'] ?? 'Hotel',
      'roomType': bookingDetails['roomType'] ?? 'Standard Room',
      'checkIn': bookingDetails['checkIn'] ?? '--/--/----',
      'checkOut': bookingDetails['checkOut'] ?? '--/--/----',
      'guests': bookingDetails['guests'] ?? 1,
      'rooms': bookingDetails['rooms'] ?? 1,
      'customerName': name,
      'customerEmail': email,
      'customerPhone': phone,
    };
    
    // Store the arguments to be used in the success handler
    Get.put<Map<String, dynamic>>(bookingArgs, permanent: true);
    try {
      // Provide haptic feedback when payment process starts
      await HapticFeedback.mediumImpact();
      isLoading.value = true;
      errorMessage.value = '';
      
      print('Creating payment order for amount: $amount');
      
      // Create order on your server
      final http.Response response = await http.post(
        Uri.parse('$_baseUrl/processPayment'),
        headers: _headers,
        body: jsonEncode(<String, Object>{
          'amount': amount,
          'currency': 'INR',
          'receipt': 'RCPT_${DateTime.now().millisecondsSinceEpoch}',
        }),
      );
      
      print('Server response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode != 200) {
        // Provide error haptic feedback
        await HapticFeedback.heavyImpact();
        final String errorMsg = 'Server error (${response.statusCode}): ${response.body}';
        errorMessage.value = errorMsg;
        print('Payment error: $errorMsg');
        return;
      }
      
      final order = jsonDecode(response.body);
      print('Created order: $order');
      
      // Verify we have the required order ID
      if (order['id'] == null) {
        throw Exception('Invalid order response from server: ${response.body}');
      }
      
      // Validate Razorpay key
      if (_razorpayKey == 'YOUR_ACTUAL_RAZORPAY_KEY_ID') {
        throw Exception('Razorpay key not configured. Please set your Razorpay key in payment_controller.dart');
      }
      
      // Open Razorpay payment gateway
      final Map<String, dynamic> options = <String, dynamic>{
        'key': _razorpayKey,
        'amount': (amount * 100).toInt(), // Convert to paise (smallest currency unit)
        'name': 'SeeMyTrip',
        'description': 'Hotel Booking Payment',
        'order_id': order['id'],
        'prefill': <String, String>{
          'contact': phone,
          'email': email,
          'name': name,
        },
        'theme': <String, String>{
          'color': '#0C4A6E', // Match your app theme
        }
      };
      
      print('Opening Razorpay with options: $options');
      _razorpay.open(options);
      
    } catch (e, stackTrace) {
      final String errorMsg = 'Failed to process payment: ${e.toString()}';
      errorMessage.value = errorMsg;
      print('Payment error: $errorMsg');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
  try {
    // Get current date and time
    final DateTime now = DateTime.now();
    final String formattedDate = '${now.day}/${now.month}/${now.year}';
    final String formattedTime = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    
    // Get the stored booking arguments
    final Map<String, dynamic> bookingArgs = Get.find<Map<String, dynamic>>();
    
    // Navigate to the booking confirmation screen
    await Get.offAllNamed(
      AppRoutes.bookingConfirmation,
      arguments: {
        'paymentDetails': {
          'paymentId': response.paymentId ?? 'N/A',
          'paymentDate': formattedDate,
          'paymentTime': formattedTime,
          'amount': bookingArgs['amount'] ?? '₹0.00',
          'status': 'Success',
        },
        'bookingDetails': {
          'hotelName': bookingArgs['hotelName'] ?? 'Hotel',
          'roomType': bookingArgs['roomType'] ?? 'Standard Room',
          'checkIn': bookingArgs['checkIn'] ?? '--/--/----',
          'checkOut': bookingArgs['checkOut'] ?? '--/--/----',
          'guests': bookingArgs['guests'] ?? 1,
          'rooms': bookingArgs['rooms'] ?? 1,
        },
        'customerDetails': {
          'name': bookingArgs['customerName'] ?? 'Guest',
          'email': bookingArgs['customerEmail'] ?? 'No email',
          'phone': bookingArgs['customerPhone'] ?? 'No phone',
        },
      },
    );
  } catch (e, stackTrace) {
    print('Error in payment success handler: $e');
    print('Stack trace: $stackTrace');
    Get.snackbar(
      'Error',
      'Payment was successful but there was an error showing the confirmation: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    errorMessage.value = 'Payment failed: ${response.message}';
    Get.snackbar(
      'Payment Failed',
      'Error: ${response.code} - ${response.message}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {
    Get.snackbar(
      'External Wallet Selected',
      'Selected: ${response.walletName}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
