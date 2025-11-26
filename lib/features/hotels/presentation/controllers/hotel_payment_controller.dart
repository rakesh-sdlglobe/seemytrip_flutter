// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// import '../../../../components/payment_controller.dart';
// import '../../../../core/routes/app_routes.dart';
// import '../../../../core/config/app_config.dart';

// class HotelPaymentController extends GetxController
//     implements PaymentCallbackHandler {
//   final String baseUrl = AppConfig.baseUrl;
//   late final PaymentController paymentController;
  
//   @override
//   void onInit() {
//     super.onInit();
//     paymentController = Get.put(PaymentController());
//   }

//   Map<String, dynamic>? bookingArgs;

//   Future<void> processHotelPayment({
//     required double amount,
//     required String name,
//     required String email,
//     required String phone,
//     required Map<String, dynamic> bookingDetails,
//   }) async {
//     bookingArgs = {
//       'amount': '₹${amount.toStringAsFixed(2)}',
//       ...bookingDetails,
//       'customerName': name,
//       'customerEmail': email,
//       'customerPhone': phone,
//     };

//     await HapticFeedback.mediumImpact();

//     final order = await paymentController.createOrder(
//       baseUrl: '$baseUrl/hotels',
//       amount: amount,
//     );

//     if (order != null && order['id'] != null) {
//       paymentController.openRazorpay(
//         orderId: order['id'],
//         amount: amount,
//         name: 'SeeMyTrip',
//         email: email,
//         phone: phone,
//         description: 'Hotel Booking Payment',
//       );
//     }
//   }

//   @override
//   void onPaymentSuccess(PaymentSuccessResponse response) {
//     final now = DateTime.now();
//     final date = '${now.day}/${now.month}/${now.year}';
//     final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}';

//     Get.offAllNamed(
//       AppRoutes.bookingConfirmation,
//       arguments: {
//         'status': 'success',
//         'paymentDetails': {
//           'paymentId': response.paymentId ?? 'N/A',
//           'orderId': response.orderId ?? 'N/A',
//           'signature': response.signature ?? 'N/A',
//           'date': date,
//           'time': time,
//           'amount': bookingArgs?['amount'] ?? '₹0.00',
//           'paymentMethod': 'Credit/Debit Card',
//           'status': 'Success',
//         },
//         'bookingDetails': {
//           'bookingId':
//               'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
//           'hotelName': bookingArgs?['hotelName'] ?? 'Hotel Name',
//           'checkIn': bookingArgs?['checkIn'] ?? '--/--/----',
//           'checkOut': bookingArgs?['checkOut'] ?? '--/--/----',
//           'guests': bookingArgs?['guests'] ?? 1,
//           'rooms': bookingArgs?['rooms'] ?? 1,
//           'roomType': bookingArgs?['roomType'] ?? 'Standard Room',
//         },
//         'customerDetails': {
//           'name': bookingArgs?['customerName'] ?? 'Guest User',
//           'email': bookingArgs?['customerEmail'] ?? 'guest@example.com',
//           'phone': bookingArgs?['customerPhone'] ?? 'Not provided',
//         },
//       },
//     );
//   }

//   @override
//   void onPaymentError(PaymentFailureResponse response) {
//     Get.snackbar(
//       'Payment Failed',
//       'Error: ${response.code} - ${response.message}',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   @override
//   void onExternalWallet(ExternalWalletResponse response) {
//     Get.snackbar(
//       'External Wallet Selected',
//       'Selected: ${response.walletName}',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }
