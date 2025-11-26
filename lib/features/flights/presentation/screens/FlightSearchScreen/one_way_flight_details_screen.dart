// ignore_for_file: avoid_bool_literals_in_conditional_expressions, avoid_catches_without_on_clauses

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dynamic_language_selector.dart';
import '../../../../../core/widgets/global_language_wrapper.dart';
import '../../../../payment/easebuzz_payment_widget.dart';
import '../../controllers/flight_controller.dart';
import 'booking_success_page.dart';

class OneWayFlightDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> flight;
  final Map<String, dynamic> searchParams;

  const OneWayFlightDetailsScreen({
    super.key,
    required this.flight,
    required this.searchParams,
  });

  @override
  State<OneWayFlightDetailsScreen> createState() =>
      _OneWayFlightDetailsScreenState();
}

class _OneWayFlightDetailsScreenState extends State<OneWayFlightDetailsScreen> {
  final FlightController _flightController = Get.find<FlightController>();

  @override
  Widget build(BuildContext context) => GlobalLanguageWrapper(
        child: Scaffold(
          appBar: AppBar(
            title: Text('flightDetails'.tr),
            elevation: 0,
            actions: <Widget>[
              QuickLanguageSwitcher(),
              const SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTripSummary(),
                _buildFlightDetails(),
                _buildFareSummary(),
                _buildAdditionalInfo(),
                _buildTravellersSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
                      'totalAmount'.tr,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${widget.flight['totalFare']?.toStringAsFixed(0) ?? '0'}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isPaymentProcessing ? null : _handleProceedToPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redCA0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isPaymentProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Proceed to Pay',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      );

  bool _isPaymentProcessing = false;

  Future<void> _handleProceedToPay() async {
    setState(() {
      _isPaymentProcessing = true;
    });

    try {
      // 1. Prebook Flight
      // Construct FlightServiceDetail
      final Map<String, dynamic> flightServiceDetail = {
        ...widget.flight,
        'Segments': widget.flight['segments'] ?? [],
      };

      final Map<String, dynamic> prebookRequest = <String, dynamic>{
        'UniqueReferencekey': widget.flight['UniqueReferencekey'],
        'Adults': widget.searchParams['adults'],
        'Children': widget.searchParams['children'],
        'Infants': widget.searchParams['infants'],
        'ReservationAmount': widget.flight['totalFare'],
        'ServiceBookPrice': widget.flight['totalFare'],
        'FlightServiceDetail': flightServiceDetail,
      };

      final Map<String, dynamic>? prebookResponse =
          await _flightController.prebookFlight(prebookRequest);

      debugPrint('DEBUG: widget.flight keys: ${widget.flight.keys}');
      debugPrint(
          'DEBUG: widget.flight UniqueReferencekey: ${widget.flight['UniqueReferencekey']}');
      debugPrint('DEBUG: prebookResponse: $prebookResponse');

      if (prebookResponse != null) {
        // 2. Proceed to Payment
        final double amount =
            double.tryParse(widget.flight['totalFare']?.toString() ?? '0') ??
                0.0;

        await Get.to(() => EasebuzzPaymentWidget(
              amount: amount,
              name: 'Guest',
              email: 'guest@example.com',
              phone: '0000000000',
              productInfo: 'Flight Booking',
              onSuccessWithResult: (result) async {
                // 3. Book Flight on Payment Success
                try {
                  // Use UniqueReferencekey from prebook response if available, else from flight details
                  // Check multiple possible paths in prebook response
                  final String? uniqueRefKey = prebookResponse['data']
                          ?['UniqueReferencekey'] ??
                      prebookResponse['UniqueReferencekey'] ??
                      prebookResponse['uniqueReferencekey'] ??
                      widget.flight['UniqueReferencekey'];

                  if (uniqueRefKey == null) {
                    Get.snackbar(
                        'Error', 'Booking Failed: Missing Reference Key',
                        backgroundColor: Colors.red, colorText: Colors.white);
                    return;
                  }

                  // Prepare Paxs
                  final List<Map<String, dynamic>> paxs = [
                    {
                      'Title': 'Mr',
                      'FirstName': 'Test',
                      'LastName': 'Passenger',
                      'PaxType': 1,
                      'DateOfBirth': '1990-01-01T00:00:00',
                      'Gender': 1,
                      'PassportNo': '',
                      'PassportExpiry': '',
                      'AddressLine1': 'Test Address',
                      'AddressLine2': '',
                      'City': 'Delhi',
                      'CountryCode': 'IN',
                      'CountryName': 'India',
                      'ContactNo': '9876543210',
                      'Email': 'test@example.com',
                      'IsLeadPax': true,
                      'FFAirline': '',
                      'FFNumber': ''
                    }
                  ];

                  // Prepare FlightServiceDetail for Booking
                  final Map<String, dynamic> flightServiceDetailBook = {
                    ...widget.flight,
                    'UniqueReferencekey': uniqueRefKey,
                    'Segments': widget.flight['segments'] ?? [],
                  };

                  final Map<String, dynamic> bookingRequest = <String, dynamic>{
                    'BookingDetails': [
                      {
                        'FlightServiceDetail': flightServiceDetailBook,
                        'Paxs': paxs,
                      }
                    ],
                    'TransactionId': result.transactionId,
                    'PaymentStatus': 'Success',
                  };

                  final Map<String, dynamic>? bookingResponse =
                      await _flightController.bookFlight(bookingRequest);

                  if (bookingResponse != null &&
                      bookingResponse['success'] == true) {
                    // Navigate to Success Page
                    await Get.off(() => BookingSuccessPage(
                          bookingId: bookingResponse['data']?['BookingId']
                                  ?.toString() ??
                              'N/A',
                          message: 'Your flight has been successfully booked!',
                        ));
                  } else {
                    Get.snackbar('Error',
                        'Booking Failed: ${bookingResponse?['message'] ?? 'Unknown error'}',
                        backgroundColor: Colors.red, colorText: Colors.white);
                  }
                } catch (e) {
                  Get.snackbar('Error', 'Booking Exception: $e',
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              onFailure: () {
                Get.snackbar('Payment Failed', 'Please try again.',
                    backgroundColor: Colors.red, colorText: Colors.white);
              },
            ));
      }
    } catch (e) {
      Get.snackbar('Error', 'Prebook Failed: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() {
          _isPaymentProcessing = false;
        });
      }
    }
  }

  Widget _buildTripSummary() {
    final String from = widget.searchParams['fromAirport'] ?? 'DEL';
    final String to = widget.searchParams['toAirport'] ?? 'BOM';
    final String dateStr = widget.searchParams['departDate'] ?? '';
    String formattedDate = dateStr;
    try {
      if (dateStr.isNotEmpty) {
        final DateTime date = DateTime.parse(dateStr);
        formattedDate = DateFormat('MMM d, yyyy').format(date);
      }
    } catch (e) {
      // keep original string if parse fails
    }

    final int adults =
        int.tryParse(widget.searchParams['adults']?.toString() ?? '1') ?? 1;
    final int children =
        int.tryParse(widget.searchParams['children']?.toString() ?? '0') ?? 0;
    final String passengers =
        '$adults Adult${adults > 1 ? 's' : ''}${children > 0 ? ', $children Child${children > 1 ? 'ren' : ''}' : ''}';
    final String travelClass = widget.searchParams['travelClass'] ?? 'Economy';

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'tripSummary'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            _buildInfoRow('from'.tr, from),
            _buildInfoRow('to'.tr, to),
            _buildInfoRow('departure'.tr, formattedDate),
            _buildInfoRow('passengers'.tr, passengers),
            _buildInfoRow('class'.tr, travelClass),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetails() {
    final String origin = widget.flight['origin'] ?? 'DEL';
    final String destination = widget.flight['destination'] ?? 'BOM';
    final String duration = widget.flight['duration'] ?? '2h 15m';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'flightItinerary'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$origin to $destination',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${'duration'.tr}: $duration',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.5, height: 1),
          _buildSegmentCard(),
        ],
      ),
    );
  }

  Widget _buildSegmentCard() {
    final segment = widget.flight['segments'] != null &&
            (widget.flight['segments'] as List).isNotEmpty
        ? widget.flight['segments'][0]
        : widget.flight;

    final String airlineName =
        segment['AirlineName'] ?? widget.flight['airlineName'] ?? 'Airline';
    final String airlineCode =
        segment['AirlineCode'] ?? widget.flight['airlineCode'] ?? '';
    final String flightNumber =
        segment['FlightNumber'] ?? widget.flight['flightNumber'] ?? '';
    final String aircraftType = segment['AircraftType'] ?? 'Aircraft';
    final String duration =
        segment['Duration'] ?? widget.flight['duration'] ?? '--';

    final String origin = segment['Origin'] ?? widget.flight['origin'] ?? 'DEL';
    final String destination =
        segment['Destination'] ?? widget.flight['destination'] ?? 'BOM';

    String departTime =
        segment['DepartureTime']?.toString().split(' ')[1] ?? '--:--';
    String arriveTime =
        segment['ArrivalTime']?.toString().split(' ')[1] ?? '--:--';

    // Format dates
    String departDate = '--';
    String arriveDate = '--';
    try {
      if (segment['DepartureTime'] != null) {
        departDate = DateFormat('MMM d, yyyy').format(
            DateTime.parse(segment['DepartureTime'].toString().split(' ')[0]));
      }
      if (segment['ArrivalTime'] != null) {
        arriveDate = DateFormat('MMM d, yyyy').format(
            DateTime.parse(segment['ArrivalTime'].toString().split(' ')[0]));
      }
    } catch (e) {
      // ignore
    }

    final int stops =
        int.tryParse(widget.flight['stopCount']?.toString() ?? '0') ?? 0;
    final String stopText = stops == 0 ? 'nonStop'.tr : '$stops Stop(s)';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Airline and flight number
            Row(
              children: <Widget>[
                // Airline logo
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://d1ufw0nild2mi8m.cloudfront.net/images/airlines/V2/svg/$airlineCode.svg',
                    fit: BoxFit.contain,
                    errorWidget:
                        (BuildContext context, String url, Object error) =>
                            const Icon(
                      Icons.airplanemode_active,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                ),

                // Airline and flight number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      airlineName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$airlineCode $flightNumber • $aircraftType',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Duration
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Flight times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        origin,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        departTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        departDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow with flight duration
                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        stopText,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.flight_takeoff,
                        color: Colors.blue, size: 20),
                    Text(
                      duration,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),

                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        destination,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        arriveTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        arriveDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Duration and stops
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${'duration'.tr}: $duration'),
                Text(stopText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSummary() {
    final double baseFare = (widget.flight['baseFare'] ?? 0).toDouble();
    final double taxes = (widget.flight['taxesAndFees'] ?? 0).toDouble();
    final double totalFare = (widget.flight['totalFare'] ?? 0).toDouble();
    final bool isRefundable = widget.flight['Refundable'] == true ||
        widget.flight['IsRefundable'] == true;
    final String baggage = widget.flight['Baggage'] ?? 'Check with airline';
    final String cabinBaggage = widget.flight['CabinBaggage'] ?? '7 kg';

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'fareSummary'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            _buildInfoRow('baseFare'.tr, '₹${baseFare.toStringAsFixed(0)}'),
            _buildInfoRow('taxesAndFees'.tr, '₹${taxes.toStringAsFixed(0)}'),
            const Divider(),
            _buildInfoRow(
              'totalAmount'.tr,
              '₹${totalFare.toStringAsFixed(0)}',
              isTotal: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Icon(
                  isRefundable ? Icons.check_circle : Icons.cancel,
                  color: isRefundable ? Colors.green : Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isRefundable ? 'fullyRefundable'.tr : 'Non-Refundable',
                  style: TextStyle(
                    color: isRefundable ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(child: _buildBaggageInfo('baggage'.tr, baggage)),
                const SizedBox(width: 16),
                Expanded(child: _buildBaggageInfo('cabin'.tr, cabinBaggage)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBaggageInfo(String label, String value) => Row(
        children: <Widget>[
          Icon(
            label == 'Baggage' ? Icons.luggage : Icons.business_center,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );

  Widget _buildAdditionalInfo() => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'additionalInformation'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 1.5),
              const SizedBox(height: 8),
              _buildInfoRow(
                'lastBookingTime'.tr,
                'Dec 25, 2024, 8:30 AM',
              ),
              _buildInfoRow(
                  'checkInCloses'.tr, '60 ${'minutesBeforeDeparture'.tr}'),
              _buildInfoRow(
                  'webCheckIn'.tr, 'availableHoursBeforeDeparture'.tr),
              _buildInfoRow('cancellationPolicy'.tr, 'asPerAirlineRules'.tr),
            ],
          ),
        ),
      );

  Widget _buildTravellersSection() => Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Additional Passengers (Optional)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select from saved travellers (0 selected)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50]?.withValues(alpha: 0.5) ??
                      Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.blue[200] ?? Colors.blue, width: 1),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Primary passenger (logged-in user) contact is required. Additional passengers from your saved travellers list can be added here.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Icon(Icons.person_add_alt_1_outlined,
                        size: 40, color: Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(height: 8),
                    Text(
                      'No saved passengers yet',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You can add passengers or proceed with primary contact only',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  color: isTotal ? Colors.blue : Colors.grey,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 16 : 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  color: isTotal ? Colors.blue : Colors.black87,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 18 : 14,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
}
