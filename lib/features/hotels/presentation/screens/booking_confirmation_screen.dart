import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../home/presentation/screens/home_screen.dart';
import 'rooms_and_guest_screen.dart' as AppColors;

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};

    // Add null checks
    final Map<String, dynamic> paymentDetails = args['paymentDetails'] ?? {};
    final Map<String, dynamic> bookingDetails = args['bookingDetails'] ?? {};
    final Map<String, dynamic> customerDetails = args['customerDetails'] ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Icon and Message
            const Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your booking has been confirmed',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Booking Summary Card
            _buildSectionHeader('Booking Summary'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                        'Booking ID', bookingDetails['bookingId'] ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(
                        'Hotel', bookingDetails['hotelName'] ?? 'N/A'),
                    _buildDetailRow(
                        'Room Type', bookingDetails['roomType'] ?? 'N/A'),
                    _buildDetailRow(
                        'Check-in', bookingDetails['checkIn'] ?? 'N/A'),
                    _buildDetailRow(
                        'Check-out', bookingDetails['checkOut'] ?? 'N/A'),
                    _buildDetailRow('Guests',
                        bookingDetails['guests']?.toString() ?? 'N/A'),
                    _buildDetailRow(
                        'Rooms', bookingDetails['rooms']?.toString() ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Details Card
            _buildSectionHeader('Payment Details'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                        'Amount Paid', paymentDetails['amount'] ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow(
                        'Payment ID', paymentDetails['paymentId'] ?? 'N/A'),
                    _buildDetailRow(
                        'Order ID', paymentDetails['orderId'] ?? 'N/A'),
                    _buildDetailRow('Payment Method',
                        paymentDetails['paymentMethod'] ?? 'N/A'),
                    _buildDetailRow('Date', paymentDetails['date'] ?? 'N/A'),
                    _buildDetailRow('Time', paymentDetails['time'] ?? 'N/A'),
                    _buildDetailRow('Status', paymentDetails['status'] ?? 'N/A',
                        valueStyle: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Customer Details Card
            _buildSectionHeader('Customer Details'),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow('Name', customerDetails['name'] ?? 'N/A'),
                    const Divider(),
                    _buildDetailRow('Email', customerDetails['email'] ?? 'N/A'),
                    _buildDetailRow('Phone', customerDetails['phone'] ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _shareBookingDetails(
                        bookingDetails,
                        paymentDetails,
                        customerDetails,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue[50],
                        foregroundColor: Colors.blue,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 8),
                          Text('Share Booking Details'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _downloadReceipt(
                        context,
                        bookingDetails,
                        paymentDetails,
                        customerDetails,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Download Receipt'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Navigate to home using the named route
                      Get.to(()=>HomeScreen());
                    },
                    child: const Text('Back to Home'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0, left: 8.0, top: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildDetailRow(String label, String value, {TextStyle? valueStyle}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: valueStyle ?? const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      );

  Future<void> _shareBookingDetails(
    Map<String, dynamic> bookingDetails,
    Map<String, dynamic> paymentDetails,
    Map<String, dynamic> customerDetails,
  ) async {
    final String shareText = '''
    🏨 *Booking Confirmation* 🏨

    *Booking ID:* ${bookingDetails['bookingId']}
    *Hotel:* ${bookingDetails['hotelName']}
    *Room Type:* ${bookingDetails['roomType']}
    *Check-in:* ${bookingDetails['checkIn']}
    *Check-out:* ${bookingDetails['checkOut']}
    *Guests:* ${bookingDetails['guests']}
    *Rooms:* ${bookingDetails['rooms']}

    *Payment Details*
    Amount: ${paymentDetails['amount']}
    Payment ID: ${paymentDetails['paymentId']}
    Status: ${paymentDetails['status']}
    
    Thank you for choosing SeeMyTrip!
    ''';

    // Copy to clipboard
    await Clipboard.setData(ClipboardData(text: shareText));

    // Show a snackbar to inform the user
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text('Booking details copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _downloadReceipt(
    BuildContext context,
    Map<String, dynamic> bookingDetails,
    Map<String, dynamic> paymentDetails,
    Map<String, dynamic> customerDetails,
  ) async {
    // TODO: Implement PDF generation and download
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt download will be available soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
