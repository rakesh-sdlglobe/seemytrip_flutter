import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class OneWayFlightDetailsScreen extends StatelessWidget {

  const OneWayFlightDetailsScreen({
    required this.flight, required this.searchParams, Key? key,
  }) : super(key: key);
  final Map<String, dynamic> flight;
  final Map<String, dynamic> searchParams;

  @override
  Widget build(BuildContext context) {
    // Print flight and search parameters for debugging
    debugPrint('✈️ One Way Flight Details: $flight');
    debugPrint('🔍 Search Parameters: $searchParams');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripSummary(),
            _buildFlightDetails(),
            _buildFareSummary(),
            _buildAdditionalInfo(),
            _buildBookingButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary() {
    final from = _extractAirportCode(flight['origin'] ?? flight['Origin']);
    final to = _extractAirportCode(flight['destination'] ?? flight['Destination']);
    final departureDate = searchParams['departureDate'] ?? '';
    final passengers = searchParams['passengers'] ?? 1;
    final travelClass = searchParams['travelClass'] ?? 'Economy';

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
          children: [
            const Text(
              'Trip Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            _buildInfoRow('From', from),
            _buildInfoRow('To', to),
            _buildInfoRow('Departure', _formatDate(departureDate)),
            _buildInfoRow('Passengers', '$passengers ${passengers == 1 ? 'Passenger' : 'Passengers'}' ),
            _buildInfoRow('Class', travelClass),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetails() {
    final segments = _extractSegments(flight['Segments'] ?? flight['segments']);
    final from = _extractAirportCode(flight['origin'] ?? flight['Origin']);
    final to = _extractAirportCode(flight['destination'] ?? flight['Destination']);
    final duration = flight['duration'] ?? flight['Duration'] ?? '';
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Text(
              'Flight Itinerary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$from to $to',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Duration: $duration',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.5, height: 1),
          ...segments.asMap().entries.map((entry) {
            final index = entry.key;
            final segment = entry.value;
            return _buildSegmentCard(
              segment,
              defaultFrom: from,
              defaultTo: to,
              segmentIndex: index,
              totalSegments: segments.length,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSegmentCard(
    dynamic segment, {
    required String defaultFrom,
    required String defaultTo,
    required int segmentIndex,
    required int totalSegments,
  }) {
    final from = _extractAirportCode(segment['origin'] ?? segment['Origin'] ?? defaultFrom);
    final to = _extractAirportCode(segment['destination'] ?? segment['Destination'] ?? defaultTo);
    final airlineCode = _extractAirlineCode(segment);
    final flightNumber = _extractFlightNumber(segment);
    final departureTime = _formatTime(segment['departureTime'] ?? segment['DepartureTime']);
    final arrivalTime = _formatTime(segment['arrivalTime'] ?? segment['ArrivalTime']);
    final duration = segment['duration'] ?? segment['Duration'] ?? '';
    final stops = segment['stops'] ?? segment['Stops'] ?? 0;
    final aircraft = segment['aircraft'] ?? segment['Aircraft'] ?? 'N/A';
    final departureDate = _formatDate(segment['departureTime'] ?? segment['DepartureTime'] ?? '');
    final arrivalDate = _formatDate(segment['arrivalTime'] ?? segment['ArrivalTime'] ?? '');

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
          children: [
            if (totalSegments > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Flight ${segmentIndex + 1} of $totalSegments',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            
            // Airline and flight number
            Row(
              children: [
                // Airline logo with error handling
                if (airlineCode.isNotEmpty)
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
                      imageUrl: 'https://d1ufw0nild2mi8m.cloudfront.net/images/airlines/V2/svg/$airlineCode.svg',
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.airplanemode_active,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                
                // Airline and flight number
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${airlineCode ?? 'Flight'} $flightNumber'.trim(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      aircraft,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Duration
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        from,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        departureTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        departureDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow with flight duration
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        stops > 0 ? '$stops ${stops == 1 ? 'stop' : 'stops'}' : 'Non-stop',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(Icons.flight_takeoff, color: Colors.blue, size: 20),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                
                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        to,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        arrivalTime,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        arrivalDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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
              children: [
                Text('Duration: $duration'),
                Text(stops > 0 ? '$stops ${stops == 1 ? 'stop' : 'stops'}' : 'Non-stop'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSummary() {
    final baseFare = double.tryParse(flight['baseFare']?.toString() ?? flight['BaseFare']?.toString() ?? '0') ?? 0.0;
    final tax = double.tryParse(flight['tax']?.toString() ?? flight['Tax']?.toString() ?? '0') ?? 0.0;
    final totalFare = double.tryParse(flight['totalFare']?.toString() ?? flight['TotalFare']?.toString() ?? '0') ?? 0.0;
    final isRefundable = flight['isRefundable'] ?? flight['IsRefundable'] ?? false;
    final baggageAllowance = flight['baggageAllowance'] ?? flight['BaggageAllowance'] ?? '7 kg';
    final cabinBaggage = flight['cabinBaggage'] ?? flight['CabinBaggage'] ?? '7 kg';

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
          children: [
            const Text(
              'Fare Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            _buildInfoRow('Base Fare', _formatCurrency(baseFare)),
            _buildInfoRow('Taxes & Fees', _formatCurrency(tax)),
            const Divider(),
            _buildInfoRow(
              'Total Amount',
              _formatCurrency(totalFare),
              isTotal: true,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isRefundable ? Icons.check_circle : Icons.cancel,
                  color: isRefundable ? Colors.green : Colors.orange,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  isRefundable ? 'Fully Refundable' : 'Non-Refundable',
                  style: TextStyle(
                    color: isRefundable ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildBaggageInfo('Baggage', baggageAllowance),
                const SizedBox(width: 16),
                _buildBaggageInfo('Cabin', cabinBaggage),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBaggageInfo(String label, String value) => Row(
      children: [
        Icon(
          label == 'Baggage' ? Icons.luggage : Icons.business_center,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
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
          children: [
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.5),
            const SizedBox(height: 8),
            _buildInfoRow('Last Booking Time', _formatDateTime(flight['lastBookingTime'] ?? '')),
            _buildInfoRow('Check-in Closes', '60 minutes before departure'),
            _buildInfoRow('Web Check-in', 'Available 48-2 hours before departure'),
            _buildInfoRow('Cancellation Policy', 'As per airline rules'),
          ],
        ),
      ),
    );

  Widget _buildBookingButton(BuildContext context) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle booking
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking flight...')),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text('Book Now'),
        ),
      ),
    );

  // Helper methods
  String _extractAirportCode(dynamic airport) {
    if (airport == null) return '';
    if (airport is String) return airport;
    if (airport is Map) {
      if (airport['Airport'] is Map) {
        return airport['Airport']['AirportCode'] ?? '';
      }
      return airport['AirportCode'] ?? airport['Code'] ?? '';
    }
    return '';
  }

  String _extractAirlineCode(dynamic segment) {
    if (segment == null) return '';
    if (segment is Map) {
      final airline = segment['Airline'] ?? segment['airline'];
      if (airline is Map) {
        return airline['Code'] ?? airline['code'] ?? '';
      }
      return airline?.toString() ?? '';
    }
    return '';
  }

  String _extractFlightNumber(dynamic segment) {
    if (segment == null) return '';
    if (segment is Map) {
      return (segment['FlightNumber'] ?? 
              segment['flightNumber'] ?? 
              segment['FlightNo'] ?? 
              segment['flightNo'] ?? 
              '').toString();
    }
    return '';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.tryParse(dateStr);
      if (date == null) return dateStr;
      
      final now = DateTime.now();
      String dayInfo = '';
      
      if (date.year == now.year && date.month == now.month) {
        if (date.day == now.day) {
          dayInfo = 'Today, ';
        } else if (date.day == now.day + 1) {
          dayInfo = 'Tomorrow, ';
        } else if (date.day == now.day - 1) {
          dayInfo = 'Yesterday, ';
        }
      }
      
      return '$dayInfo${DateFormat('MMM d, y').format(date)}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    try {
      final time = DateTime.tryParse(timeStr);
      if (time == null) return timeStr;
      return DateFormat('h:mm a').format(time);
    } catch (e) {
      return timeStr;
    }
  }
  
  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.tryParse(dateTimeStr);
      if (dateTime == null) return dateTimeStr;
      
      final now = DateTime.now();
      String dayInfo = '';
      
      if (dateTime.year == now.year && dateTime.month == now.month) {
        if (dateTime.day == now.day) {
          dayInfo = 'Today, ';
        } else if (dateTime.day == now.day + 1) {
          dayInfo = 'Tomorrow, ';
        } else if (dateTime.day == now.day - 1) {
          dayInfo = 'Yesterday, ';
        }
      }
      
      return '$dayInfo${DateFormat('h:mm a • d MMM yyyy').format(dateTime)}';
    } catch (e) {
      return dateTimeStr;
    }
  }

  String _formatCurrency(dynamic amount) {
    if (amount is String) {
      amount = double.tryParse(amount) ?? 0;
    }
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    );
    return formatter.format(amount);
  }

  List<dynamic> _extractSegments(dynamic segments) {
    if (segments == null) return [];
    if (segments is List) return segments;
    return [segments];
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        children: [
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