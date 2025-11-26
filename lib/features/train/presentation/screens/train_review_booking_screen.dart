// ignore_for_file: always_specify_types, avoid_catches_without_on_clauses

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../payment/easebuzz_payment_widget.dart';
import '../controllers/train_detail_controller.dart';

class TrainReviewBookingScreen extends StatefulWidget {

  const TrainReviewBookingScreen({
    required this.trainName, required this.trainNumber, required this.startStation, required this.endStation, required this.seatClass, required this.price, required this.trainNumberParam, required this.journeyDate, required this.fromStnCode, required this.toStnCode, required this.jClass, required this.jQuota, required this.boardingStationCode, required this.passengers, Key? key,
  }) : super(key: key);
  final String trainName;
  final String trainNumber;
  final String startStation;
  final String endStation;
  final String seatClass;
  final double price;
  final String trainNumberParam;
  final String journeyDate; // yyyyMMdd format
  final String fromStnCode;
  final String toStnCode;
  final String jClass;
  final String jQuota;
  final String boardingStationCode;
  final List<Map<String, dynamic>> passengers;

  @override
  State<TrainReviewBookingScreen> createState() => _TrainReviewBookingScreenState();
}

class _TrainReviewBookingScreenState extends State<TrainReviewBookingScreen> {
  final TrainDetailController trainDetailController = Get.find<TrainDetailController>();
  bool _isBlockingSeats = false;

  Future<void> _handleProceedToPay() async {
    // First, block seats
    setState(() {
      _isBlockingSeats = true;
    });

    try {
      print('🔒 Blocking seats before payment...');
      // Format journeyDate from yyyyMMdd to yyyy-MM-dd
      String formattedJourneyDate;
      try {
        // Parse yyyyMMdd format (e.g., "20251125")
        final String dateStr = widget.journeyDate;
        if (dateStr.length == 8) {
          // Manual parsing: yyyyMMdd -> yyyy-MM-dd
          final String year = dateStr.substring(0, 4);
          final String month = dateStr.substring(4, 6);
          final String day = dateStr.substring(6, 8);
          formattedJourneyDate = '$year-$month-$day';
        } else {
          // If already in yyyy-MM-dd format, use as is
          formattedJourneyDate = widget.journeyDate;
        }
      } catch (e) {
        // Fallback: try DateFormat parsing
        formattedJourneyDate = DateFormat('yyyy-MM-dd').format(
          DateFormat('yyyyMMdd').parse(widget.journeyDate),
        );
      }
      print('📅 Formatted journeyDate: $formattedJourneyDate (from ${widget.journeyDate})');
      
      final Map<String, dynamic>? blockResult = await trainDetailController.blockSeats(
        trainNumber: widget.trainNumberParam,
        journeyDate: formattedJourneyDate,
        fromStnCode: widget.fromStnCode,
        toStnCode: widget.toStnCode,
        jClass: widget.jClass,
        jQuota: widget.jQuota,
        boardingStationCode: widget.boardingStationCode,
        passengers: widget.passengers,
      );

      if (blockResult != null) {
        print('✅ Seats blocked successfully: $blockResult');
        // Proceed to payment
        if (mounted) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EasebuzzPaymentWidget(
                amount: (() {
                  final double? total = double.tryParse(
                          widget.price?.toString() ??
                          '');
                  if (total != null) return total;
                  final double base = double.tryParse(
                          widget.price?.toString() ??
                          '0') ??
                      0.0;
                  final double tax = double.tryParse(
                          widget.price?.toString() ??
                          '0') ??
                      0.0;
                  return base + tax;
                })(),
                name: (() {
                  if (Get.arguments == null) return 'Guest';
                  final String fullName = (Get.arguments?['fullName'] ?? '').toString();
                  if (fullName.trim().isNotEmpty) return fullName.trim();
                  final String first = (Get.arguments?['firstName'] ?? '').toString();
                  final String last = (Get.arguments?['lastName'] ?? '').toString();
                  final String combined = ('$first $last').trim();
                  return combined.isNotEmpty ? combined : 'Guest';
                })(),
                email: (() {
                  if (Get.arguments == null) return 'guest@example.com';
                  final String e = (Get.arguments?['email'] ?? '').toString().trim();
                  return e.isNotEmpty ? e : 'guest@example.com';
                })(),
                phone: (() {
                  if (Get.arguments == null) return '0000000000';
                  final String p = (Get.arguments?['phone'] ?? Get.arguments?['mobile'] ?? '').toString().trim();
                  return p.isNotEmpty ? p : '0000000000';
                })(),
                productInfo: (() {
                  if (Get.arguments == null) return 'Train Booking';
                  final String fromCode = (Get.arguments?['origin'] ?? Get.arguments?['Origin'] ?? '').toString();
                  final String toCode = (Get.arguments?['destination'] ?? Get.arguments?['Destination'] ?? '').toString();
                  if (fromCode.isNotEmpty && toCode.isNotEmpty) {
                    return 'Train Booking - $fromCode to $toCode';
                  }
                  return 'Train Booking';
                })(),
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Payment successful! Booking confirmed.')),
                  );
                },
                onFailure: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Payment failed. Please try again.')),
                  );
                },
              ),
            ),
          );
        }
      } else {
        // Seat blocking failed
        if (mounted) {
          Get.snackbar(
            'Error',
            'Failed to block seats. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print('❌ Error blocking seats: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'An error occurred while blocking seats. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBlockingSeats = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: Column(
        children: <Widget>[
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.primaryColor.withValues(alpha: 0.1),
            child: Row(
              children: <Widget>[
                Icon(Icons.timer, color: theme.primaryColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Complete your booking within 10 minutes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Journey Summary Card
                  _buildJourneyCard(theme),
                  const SizedBox(height: 24),

                  // Price Breakdown
                  _buildSectionHeader('Price Breakdown'),
                  const SizedBox(height: 16),
                  _buildPriceRow('Base Fare', '₹${widget.price}'),
                  const Divider(height: 32),
                  _buildPriceRow('Total Amount', '₹${widget.price}', isTotal: true),
                ],
              ),
            ),
          ),

          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Total Amount',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${widget.price}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    onPressed: _isBlockingSeats ? null : _handleProceedToPay,
                    child: _isBlockingSeats
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Proceed to Pay'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(ThemeData theme) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // From - To Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // From
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'From',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.startStation,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '04 Oct, 5:40 PM',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                // Train Icon
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.train, size: 20),
                ),

                // To
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'To',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.endStation,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '05 Oct, 8:15 AM',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 32),

            // Train Details
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.directions_train,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.trainName} (${widget.trainNumber})',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.seatClass,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildSectionHeader(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      );

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                color: isTotal ? AppColors.primary : null,
              ),
            ),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                color: isTotal ? AppColors.primary : null,
              ),
            ),
          ],
        ),
      );

  AppBar _buildAppBar(ThemeData theme) => AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Get.back(),
          color: Colors.white,
        ),
        title: const Text(
          'Review Booking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
}
