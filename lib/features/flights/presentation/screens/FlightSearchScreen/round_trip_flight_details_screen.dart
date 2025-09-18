import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoundTripFlightDetailsScreen extends StatelessWidget {

  const RoundTripFlightDetailsScreen({
    required this.flight, required this.searchParams, Key? key,
  }) : super(key: key);
  final Map<String, dynamic> flight;
  final Map<String, dynamic> searchParams;

  // Helper method to format date and time in a more readable way
  String _formatDateTime(String dateTimeStr) {
    try {
      final dateTime = DateTime.tryParse(dateTimeStr);
      if (dateTime == null) return dateTimeStr;
      
      final now = DateTime.now();
      final difference = dateTime.difference(DateTime(now.year, now.month, now.day));
      
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
      
      // Format: "Today, 2:30 PM • 18 Sep 2023"
      return '$dayInfo${DateFormat('h:mm a • d MMM yyyy').format(dateTime)}';
      
    } catch (e) {
      return dateTimeStr;
    }
  }

  // Helper method to build a card for flight segments
  Widget _buildFlightSegmentCard(String title, Map<String, dynamic> segment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildInfoRow('Airline', segment['airlineName'] ?? 'N/A'),
            _buildInfoRow('Flight Number', segment['flightNumber'] ?? 'N/A'),
            _buildInfoRow('From', '${segment['origin'] ?? 'N/A'}'),
            _buildInfoRow('To', '${segment['destination'] ?? 'N/A'}'),
            _buildInfoRow('Departure', _formatDateTime(segment['departureTime'] ?? '')),
            _buildInfoRow('Arrival', _formatDateTime(segment['arrivalTime'] ?? '')),
            _buildInfoRow('Duration', segment['duration'] ?? 'N/A'),
            _buildInfoRow('Stops', '${segment['stopCount'] ?? 0} ${segment['stopCount'] == 1 ? 'stop' : 'stops'}'),
            if (segment['operatedBy'] != null)
              _buildInfoRow('Operated By', segment['operatedBy']),
          ],
        ),
      ),
    );
  }

  // Helper method to build a row of information
  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label.isEmpty ? '' : '$label:',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[600],
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Print flight and search parameters for debugging
    debugPrint('✈️ Flight Details: $flight');
    debugPrint('🔍 Search Parameters: $searchParams');

    // Extract flight details with null safety
    final outboundFlight = {
      'airlineName': flight['airlineName'],
      'flightNumber': flight['flightNumber'],
      'origin': flight['origin'],
      'destination': flight['destination'],
      'departureTime': flight['departureTime'],
      'arrivalTime': flight['arrivalTime'],
      'duration': flight['duration'],
      'stopCount': flight['stopCount'],
      'operatedBy': flight['operatedBy'],
    };

    final returnFlight = {
      'airlineName': flight['airlineName'], // Assuming same airline for return
      'flightNumber': flight['flightNumber'], // Adjust if return flight has different number
      'origin': flight['destination'], // Return flight origin is the outbound destination
      'destination': flight['origin'], // Return flight destination is the outbound origin
      'departureTime': flight['returnDepartureTime'],
      'arrivalTime': flight['returnArrivalTime'],
      'duration': flight['returnDuration'],
      'stopCount': flight['returnStopCount'],
      'operatedBy': flight['operatedBy'],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Summary Card
            Card(
              margin: const EdgeInsets.all(16.0),
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
                    const Divider(),
                    _buildInfoRow('From', searchParams['fromAirport'] ?? 'N/A'),
                    _buildInfoRow('To', searchParams['toAirport'] ?? 'N/A'),
                    _buildInfoRow('Departure', _formatDateTime(searchParams['departDate'] ?? '')),
                    if (searchParams['returnDate'] != null)
                      _buildInfoRow('Return', _formatDateTime(searchParams['returnDate'] ?? '')),
                    _buildInfoRow('Passengers', '${searchParams['adults'] ?? 1} Adult${searchParams['adults'] != 1 ? 's' : ''}'),
                    if ((searchParams['children'] ?? 0) > 0)
                      _buildInfoRow('', '${searchParams['children']} Child${searchParams['children'] != 1 ? 'ren' : ''}'),
                    if ((searchParams['infants'] ?? 0) > 0)
                      _buildInfoRow('', '${searchParams['infants']} Infant${searchParams['infants'] != 1 ? 's' : ''}'),
                    _buildInfoRow('Class', searchParams['travelClass'] ?? 'Economy'),
                  ],
                ),
              ),
            ),

            // Outbound Flight
            _buildFlightSegmentCard('Outbound Flight', outboundFlight),

            // Return Flight
            _buildFlightSegmentCard('Return Flight', returnFlight),

            // Fare Details
            Card(
              margin: const EdgeInsets.all(16.0),
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
                    const Divider(),
                    _buildInfoRow('Base Fare', '₹${flight['baseFare']?.toStringAsFixed(2) ?? '0.00'}'),
                    _buildInfoRow('Taxes & Fees', '₹${flight['tax']?.toStringAsFixed(2) ?? '0.00'}'),
                    const Divider(),
                    _buildInfoRow(
                      'Total Amount',
                      '₹${flight['totalFare']?.toStringAsFixed(2) ?? '0.00'}',
                      isTotal: true,
                    ),
                    const SizedBox(height: 8),
                    if (flight['isRefundable'] == true)
                      const Text(
                        '🔄 Fully Refundable',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        '⚠️ Non-refundable',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Additional Information
            Card(
              margin: const EdgeInsets.all(16.0),
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
                    const Divider(),
                    _buildInfoRow('Baggage Allowance', flight['baggageAllowance'] ?? '7 kg'),
                    _buildInfoRow('Cabin Baggage', flight['cabinBaggage'] ?? '7 kg'),
                    _buildInfoRow('Meal', flight['mealIncluded'] == true ? 'Included' : 'Not Included'),
                    _buildInfoRow('Aircraft Type', flight['aircraftType'] ?? 'N/A'),
                    if (flight['lastBookingTime'] != null)
                      _buildInfoRow('Last Booking Time', _formatDateTime(flight['lastBookingTime'])),
                  ],
                ),
              ),
            ),

            // Book Now Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle booking
                    // You can add navigation to booking screen here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTripSummary() {
    final String from = _extractAirportCode(flight['origin'] ?? flight['Origin']);
    final String to = _extractAirportCode(flight['destination'] ?? flight['Destination']);
    final String departureDate = searchParams['departureDate'] ?? '';
    final String returnDate = searchParams['returnDate'] ?? '';
    final int passengers = searchParams['passengers'] ?? 1;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Your Trip',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTripRow('From', from),
            _buildTripRow('To', to),
            _buildTripRow('Departure', _formatDate(departureDate)),
            if (returnDate.isNotEmpty)
              _buildTripRow('Return', _formatDate(returnDate)),
            _buildTripRow('Passengers', passengers.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildOutboundFlight() {
    final List segments = _extractSegments(flight['Segments'] ?? flight['segments']);
    final String from = _extractAirportCode(flight['origin'] ?? flight['Origin']);
    final String to = _extractAirportCode(flight['destination'] ?? flight['Destination']);
    
    return _buildFlightSection(
      title: 'Outbound Flight',
      date: searchParams['departureDate'] ?? '',
      segments: segments,
      defaultFrom: from,
      defaultTo: to,
    );
  }

  Widget _buildReturnFlight() {
    final List returnSegments = _extractSegments(flight['ReturnSegments'] ?? flight['returnSegments']);
    if (returnSegments.isEmpty) return const SizedBox.shrink();
    
    // For return flight, get origin and destination from segments
    String from = '';
    String to = '';
    
    if (returnSegments.isNotEmpty) {
      // Get origin from first segment
      final firstSegment = returnSegments.first;
      from = _extractAirportCode(firstSegment['origin'] ?? firstSegment['Origin'] ?? '');
      
      // Get destination from last segment
      final lastSegment = returnSegments.last;
      to = _extractAirportCode(lastSegment['destination'] ?? lastSegment['Destination'] ?? '');
    }
    
    // Fallback to reversed origin/destination if couldn't extract from segments
    if (from.isEmpty || to.isEmpty) {
      from = _extractAirportCode(flight['destination'] ?? flight['Destination'] ?? '');
      to = _extractAirportCode(flight['origin'] ?? flight['Origin'] ?? '');
    }
    
    return _buildFlightSection(
      title: 'Return Flight',
      date: searchParams['returnDate'] ?? '',
      segments: returnSegments,
      defaultFrom: from,
      defaultTo: to,
    );
  }

  Widget _buildFlightSection({
    required String title,
    required String date,
    required List<dynamic> segments,
    required String defaultFrom,
    required String defaultTo,
  }) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '$title • ${_formatDate(date)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...segments.asMap().entries.map((MapEntry<int, dynamic> entry) {
            final int index = entry.key;
            final dynamic segment = entry.value;
            
            // For each segment, try to get its specific origin and destination
            String segmentFrom = _extractAirportCode(segment['origin'] ?? segment['Origin'] ?? '');
            String segmentTo = _extractAirportCode(segment['destination'] ?? segment['Destination'] ?? '');
            
            // Fall back to the provided defaults if not found in segment
            if (segmentFrom.isEmpty) segmentFrom = defaultFrom;
            if (segmentTo.isEmpty) segmentTo = defaultTo;
            
            return _buildSegmentCard(
              segment,
              defaultFrom: segmentFrom,
              defaultTo: segmentTo,
              segmentIndex: index,
              totalSegments: segments.length,
            );
          }),
        ],
      ),
    );

  Widget _buildSegmentCard(
    dynamic segment, {
    required String defaultFrom,
    required String defaultTo,
    required int segmentIndex,
    required int totalSegments,
  }) {
    final String from = _extractAirportCode(segment['origin'] ?? segment['Origin'] ?? defaultFrom);
    final String to = _extractAirportCode(segment['destination'] ?? segment['Destination'] ?? defaultTo);
    final String airlineCode = _extractAirlineCode(segment);
    final String flightNumber = _extractFlightNumber(segment);
    final String departureTime = _formatTime(segment['departureTime'] ?? segment['DepartureTime']);
    final String arrivalTime = _formatTime(segment['arrivalTime'] ?? segment['ArrivalTime']);
    final duration = segment['duration'] ?? segment['Duration'] ?? '';
    final stops = segment['stops'] ?? segment['Stops'] ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (totalSegments > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Flight ${segmentIndex + 1} of $totalSegments',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            Row(
              children: <Widget>[
                // Airline logo
                if (airlineCode.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: 'https://d1ufw0nild2mi8m.cloudfront.net/images/airlines/V2/svg/$airlineCode.svg',
                    width: 40,
                    height: 40,
                    errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.airplanemode_active),
                  ),
                const SizedBox(width: 16),
                // Flight number
                Text(
                  '${airlineCode ?? ''} $flightNumber',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Flight times
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      from,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(departureTime),
                  ],
                ),
                const Icon(Icons.arrow_forward, color: Colors.blue),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      to,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(arrivalTime),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Duration and stops
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text('Duration: $duration'),
                  ),
                  Text(stops > 0 ? '$stops ${stops == 1 ? 'stop' : 'stops'}' : 'Non-stop'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFareSummary() {
    final baseFare = flight['baseFare'] ?? flight['BaseFare'] ?? 0;
    final tax = flight['tax'] ?? flight['Tax'] ?? 0;
    final totalFare = flight['totalFare'] ?? flight['TotalFare'] ?? 0;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Fare Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFareRow('Base Fare', _formatCurrency(baseFare)),
            _buildFareRow('Taxes & Fees', _formatCurrency(tax)),
            const Divider(),
            _buildFareRow(
              'Total',
              _formatCurrency(totalFare),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

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

  String _formatDate(String date) {
    if (date.isEmpty) return '';
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat('EEE, MMM d, y').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  String _formatTime(dynamic time) {
    if (time == null) return '';
    if (time is DateTime) return DateFormat('HH:mm').format(time);
    final String str = time.toString();
    if (str.contains('T')) {
      try {
        final DateTime dateTime = DateTime.parse(str);
        return DateFormat('HH:mm').format(dateTime);
      } catch (e) {
        return str;
      }
    }
    return str;
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '₹0';
    final num number = amount is num ? amount : double.tryParse(amount.toString()) ?? 0;
    return '₹${number.toStringAsFixed(2)}';
  }

  List<dynamic> _extractSegments(dynamic segments) {
    if (segments == null) return <dynamic>[];
    if (segments is List) return segments;
    return <dynamic>[segments];
  }

  Widget _buildTripRow(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

  Widget _buildFareRow(String label, String value, {bool isTotal = false}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.blue : Colors.grey,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal ? Colors.blue : Colors.black,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
}
