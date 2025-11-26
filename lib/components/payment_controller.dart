// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class PaymentController extends GetxController {
//   final Razorpay _razorpay = Razorpay();
//   final String razorpayKey = 'rzp_test_8PKYstLwYTk5Qy';
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _razorpay
//       ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
//       ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
//       ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void onClose() {
//     _razorpay.clear();
//     super.onClose();
//   }

//   Future<Map<String, dynamic>?> createOrder({
//     required String baseUrl,
//     required double amount,
//   }) async {
//     try {
//       isLoading.value = true;
//       final response = await http.post(
//         Uri.parse('$baseUrl/processPayment'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({
//           'amount': amount,
//           'currency': 'INR',
//           'receipt': 'RCPT_${DateTime.now().millisecondsSinceEpoch}',
//         }),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         errorMessage.value =
//             'Server error (${response.statusCode}): ${response.body}';
//         return null;
//       }
//     } catch (e) {
//       errorMessage.value = 'Failed to create order: $e';
//       return null;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void openRazorpay({
//     required String orderId,
//     required double amount,
//     required String name,
//     required String email,
//     required String phone,
//     String description = '',
//     String themeColor = '#0C4A6E',
//   }) {
//     if (razorpayKey.isEmpty || razorpayKey == 'YOUR_RAZORPAY_KEY') {
//       throw Exception('Razorpay key not configured. Please set a valid Razorpay key.');
//     }

//     final options = {
//       'key': razorpayKey,
//       'amount': (amount * 100).toInt(),
//       'name': name,
//       'description': description,
//       'order_id': orderId,
//       'prefill': {
//         'contact': phone,
//         'email': email,
//         'name': name,
//       },
//       'theme': {
//         'color': themeColor,
//       }
//     };

//     _razorpay.open(options);
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Get.find<PaymentCallbackHandler>()
//         .onPaymentSuccess(response);
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     Get.find<PaymentCallbackHandler>()
//         .onPaymentError(response);
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Get.find<PaymentCallbackHandler>()
//         .onExternalWallet(response);
//   }
// }

// abstract class PaymentCallbackHandler {
//   void onPaymentSuccess(PaymentSuccessResponse response);
//   void onPaymentError(PaymentFailureResponse response);
//   void onExternalWallet(ExternalWalletResponse response);
// }
