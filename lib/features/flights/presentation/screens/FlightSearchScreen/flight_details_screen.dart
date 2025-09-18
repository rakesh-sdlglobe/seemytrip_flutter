import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FlightDetailsScreen extends StatelessWidget {
  FlightDetailsScreen({
    Key? key,
    required this.flight,
    required this.searchParams,
  }) : super(key: key);

  final Map<String, dynamic> flight;
  final Map<String, dynamic> searchParams;

  // Return an airline logo URL (adjust to your real provider if needed)
  String _getAirlineLogoUrl(String iataCode) {
    if (iataCode.isEmpty) return '';
    return 'https://d1ufw0nild2mi8m.cloudfront.net/images/airlines/V2/svg/$iataCode.svg';
  }

  // Helper to safely get string values with fallback
  String _safeStr(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value.trim();
    return value.toString().trim();
  }
  
  // Helper to parse date time from various string formats
  DateTime? _tryParseDateTime(String dateTimeStr) {
    if (dateTimeStr.isEmpty) return null;
    
    try {
      // Try parsing ISO 8601 format
      if (dateTimeStr.contains('T')) {
        return DateTime.parse(dateTimeStr).toLocal();
      }
      
      // Try common date time formats
      final formats = [
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-dd HH:mm',
        'dd-MM-yyyy HH:mm',
        'MM/dd/yyyy HH:mm',
        'dd/MM/yyyy HH:mm',
        'yyyy/MM/dd HH:mm',
        'dd MMM yyyy HH:mm',
        'dd MMMM yyyy HH:mm',
      ];
      
      for (var format in formats) {
        try {
          return DateFormat(format).parse(dateTimeStr);
        } catch (e) {
          // Try next format
          continue;
        }
      }
      
      // If no format worked, try parsing just the time
      final timeMatch = RegExp(r'(\d{1,2}:\d{2})').firstMatch(dateTimeStr);
      if (timeMatch != null) {
        final now = DateTime.now();
        final timeParts = timeMatch.group(1)!.split(':');
        return DateTime(now.year, now.month, now.day, 
            int.parse(timeParts[0]), int.parse(timeParts[1]));
      }
      
      return null;
    } catch (e) {
      print('⚠️ Error parsing date time "$dateTimeStr": $e');
      return null;
    }
  }
  
  // Helper to get a value from a dynamic object with multiple possible keys
  String? _getValueFromDynamic(dynamic obj, List<String> keys) {
    if (obj == null) return null;
    
    // If it's a map, try each key
    if (obj is Map) {
      for (final key in keys) {
        if (obj[key] != null) {
          return obj[key].toString();
        }
      }
      return null;
    }
    
    // If it's a string, try to extract the value using regex
    if (obj is String) {
      for (final key in keys) {
        if (obj.toLowerCase().contains(key.toLowerCase())) {
          return obj;
        }
      }
    }
    
    return obj.toString();
  }

  String _formatDateTime(String? dtStr) {
    if (dtStr == null || dtStr.isEmpty) return '--/--/----';
    try {
      final dt = _tryParseDateTime(dtStr);
      if (dt != null) {
        return DateFormat('EEE, dd MMM yyyy').format(dt);
      }
      
      // Try to extract date if available
      final dateMatch = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(dtStr);
      if (dateMatch != null) {
        final date = DateTime.tryParse(dateMatch.group(1)!);
        if (date != null) {
          return DateFormat('EEE, dd MMM yyyy').format(date);
        }
      }
      
      return dtStr;
    } catch (e) {
      print('⚠️ Error formatting date: $e');
      return dtStr ?? '--/--/----';
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return '--:--';
    try {
      // Try to parse as full datetime first
      final dt = _tryParseDateTime(timeStr);
      if (dt != null) {
        return DateFormat('HH:mm').format(dt);
      }
      
      // Try to extract just the time part
      final timeMatch = RegExp(r'(\d{1,2}:\d{2})').firstMatch(timeStr);
      if (timeMatch != null) {
        return timeMatch.group(1)!;
      }
      
      return timeStr;
    } catch (e) {
      print('⚠️ Error formatting time: $e');
      return timeStr;
    }
  }

  String _calcDuration(String? startStr, String? endStr) {
    try {
      if (startStr == null || endStr == null) return '--h --m';
      
      final start = _tryParseDateTime(startStr);
      final end = _tryParseDateTime(endStr);
      
      if (start == null || end == null) {
        // Try to extract times directly from strings as a fallback
        final startTimeMatch = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(startStr);
        final endTimeMatch = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(endStr);
        
        if (startTimeMatch != null && endTimeMatch != null) {
          final startHour = int.parse(startTimeMatch.group(1)!);
          final startMin = int.parse(startTimeMatch.group(2)!);
          final endHour = int.parse(endTimeMatch.group(1)!);
          final endMin = int.parse(endTimeMatch.group(2)!);
          
          var hours = endHour - startHour;
          var minutes = endMin - startMin;
          
          if (minutes < 0) {
            hours--;
            minutes += 60;
          }
          
          if (hours < 0) hours += 24;
          
          return '${hours}h ${minutes}m';
        }
        
        return '--h --m';
      }
      
      Duration diff = end.difference(start);
      if (diff.isNegative) diff = diff + const Duration(days: 1);
      
      final h = diff.inHours;
      final m = diff.inMinutes.remainder(60);
      return '${h}h ${m}m';
    } catch (e) {
      print('⚠️ Error calculating duration: $e');
      return '--h --m';
    }
  }

  Widget _airlineLogo(String code) {
    if (code.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.airplanemode_active, size: 18, color: Colors.blue),
      );
    }
    final url = _getAirlineLogoUrl(code);
    if (url.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.airplanemode_active, size: 18, color: Colors.blue),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.contain,
      placeholder: (c, u) => Container(
        color: Colors.grey[200],
        child: const Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
      ),
      errorWidget: (c, u, e) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.airplanemode_active, size: 18, color: Colors.blue),
      ),
    );
  }

  // Helper function to get value with multiple fallbacks
  String _getValueWithFallbacks(Map<String, dynamic> map, List<String> keys, {String defaultValue = ''}) {
    for (final key in keys) {
      if (map[key] != null) return map[key].toString();
    }
    return defaultValue;
  }

  // Build a card for one segment
  Widget _buildSegmentCard(Map<String, dynamic> segment, {
    required String defaultFrom,
    required String defaultTo,
    required int segmentIndex,
    required int totalSegments,
    required BuildContext context,
  }) {
    // Debug print for the segment being rendered
    print('\n🔄 Rendering Segment $segmentIndex:');
    segment.forEach((key, value) {
      print('   - $key: ${value?.toString() ?? 'null'} (${value?.runtimeType})');
    });
    
    // Extract airline information with fallbacks
    final airlineName = _safeStr(
      _getValueWithFallbacks(segment, [
        'AirlineName', 
        'Airline.Name',
        'airline',
        'airlineName',
        'carrier.name',
        'carrierName',
      ]),
      defaultValue: 'Unknown Airline'
    );
    
    final flightNumber = _safeStr(
      _getValueWithFallbacks(segment, [
        'FlightNumber',
        'FlightNo',
        'flightNumber',
        'flightNo',
        'flight'
      ]),
      defaultValue: ''
    );
    
    final airlineCode = _safeStr(
      _getValueWithFallbacks(segment, [
        'AirlineCode',
        'Airline.Code',
        'airlineCode',
        'Carrier',
        'carrier',
        'airline',
        'carrier.code',
        'carrierCode'
      ])
    );

    // Extract departure and arrival times with fallbacks
    String departureFull = _getValueWithFallbacks(segment, [
      'DepartureTime',
      'Departure',
      'departure',
      'departureTime',
      'depTime',
      'std',
      'stdTime',
      'scheduledDeparture',
      'departureDateTime',
      'departureDate'
    ]);
    
    String arrivalFull = _getValueWithFallbacks(segment, [
      'ArrivalTime',
      'Arrival',
      'arrival',
      'arrivalTime',
      'sta',
      'staTime',
      'scheduledArrival',
      'arrivalDateTime',
      'arrivalDate',
    ]);
    
    // Debug log for raw date/time values
    print('📅 Raw Departure: $departureFull (${departureFull.runtimeType})');
    print('📅 Raw Arrival: $arrivalFull (${arrivalFull.runtimeType})');
    
    // If we have a segmentTime object, use that instead
    if (segment['segmentTime'] != null) {
      final segmentTime = segment['segmentTime'];
      final depTime = _getValueFromDynamic(segmentTime, ['departure', 'departureTime', 'depTime', 'std']);
      final arrTime = _getValueFromDynamic(segmentTime, ['arrival', 'arrivalTime', 'arrTime', 'sta']);
      
      if (depTime != null && depTime.isNotEmpty) departureFull = depTime;
      if (arrTime != null && arrTime.isNotEmpty) arrivalFull = arrTime;
      
      print('🔄 Using segmentTime - Departure: $departureFull, Arrival: $arrivalFull');
    }
    
      // Initialize variables with default values
    String departTime = '--:--';
    String arriveTime = '--:--';
    String departDate = '--/--/----';
    String arriveDate = '--/--/----';
    String flightDuration = _getValueWithFallbacks(segment, [
      'Duration',
      'DurationTime',
      'TravelTime',
      'duration',
      'flightDuration',
      'journeyDuration'
    ]);

    // Parse and format departure time and date
    if (departureFull.isNotEmpty) {
      try {
        final depDt = _tryParseDateTime(departureFull);
        if (depDt != null) {
          departTime = DateFormat('HH:mm').format(depDt);
          departDate = DateFormat('EEE, dd MMM yyyy').format(depDt);
        } else {
          // Try to extract time from string if parsing as DateTime failed
          final timeMatch = RegExp(r'(\d{1,2}:\d{2})').firstMatch(departureFull);
          if (timeMatch != null) departTime = timeMatch.group(1)!;
          
          // Try to extract date if available
          final dateMatch = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(departureFull);
          if (dateMatch != null) {
            final date = DateTime.tryParse(dateMatch.group(1)!);
            if (date != null) {
              departDate = DateFormat('EEE, dd MMM yyyy').format(date);
            }
          }
        }
      } catch (e) {
        print('⚠️ Error parsing departure time: $e');
      }
    }
    
    // Parse and format arrival time and date
    if (arrivalFull.isNotEmpty) {
      try {
        final arrDt = _tryParseDateTime(arrivalFull);
        if (arrDt != null) {
          arriveTime = DateFormat('HH:mm').format(arrDt);
          arriveDate = DateFormat('EEE, dd MMM yyyy').format(arrDt);
        } else {
          // Try to extract time from string if parsing as DateTime failed
          final timeMatch = RegExp(r'(\d{1,2}:\d{2})').firstMatch(arrivalFull);
          if (timeMatch != null) arriveTime = timeMatch.group(1)!;
          
          // Try to extract date if available
          final dateMatch = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(arrivalFull);
          if (dateMatch != null) {
            final date = DateTime.tryParse(dateMatch.group(1)!);
            if (date != null) {
              arriveDate = DateFormat('EEE, dd MMM yyyy').format(date);
            }
          }
        }
      } catch (e) {
        print('⚠️ Error parsing arrival time: $e');
      }
    }
    
    // If duration is not available but we have both departure and arrival times, calculate it
    if ((flightDuration.isEmpty || flightDuration == '--') && departureFull.isNotEmpty && arrivalFull.isNotEmpty) {
      try {
        final depTime = _tryParseDateTime(departureFull);
        final arrTime = _tryParseDateTime(arrivalFull);
        
        if (depTime != null && arrTime != null) {
          Duration diff = arrTime.difference(depTime);
          if (diff.isNegative) diff = diff + const Duration(days: 1);
          final h = diff.inHours;
          final m = diff.inMinutes.remainder(60);
          flightDuration = '${h}h ${m}m';
        }
      } catch (e) {
        print('⚠️ Error calculating duration: $e');
        // Fallback to simple calculation if parsing fails
        flightDuration = _calcDuration(departureFull, arrivalFull);
      }
    } else if (flightDuration.isEmpty || flightDuration == '--') {
      // If we still don't have a duration, use the calculated one
      flightDuration = _calcDuration(departureFull, arrivalFull);
    }

    final from = _safeStr(segment['Origin'] ?? segment['From'] ?? segment['origin'] ?? defaultFrom);
    final to = _safeStr(segment['Destination'] ?? segment['To'] ?? segment['destination'] ?? defaultTo);

    final baggage = _safeStr(segment['Baggage'] ?? segment['BaggageAllowance'] ?? segment['CheckedBaggage'] ?? '');
    final cabinBaggage = _safeStr(segment['CabinBaggage'] ?? segment['HandBaggage'] ?? '');

    final aircraft = _safeStr(segment['AircraftType'] ?? segment['Equipment'] ?? '');

    final stopCountVal = segment['StopCount'] ??
        segment['Stops'] ??
        (totalSegments > 1 ? totalSegments - 1 : 0);
    final stopCount = (stopCountVal is int) ? stopCountVal : int.tryParse(stopCountVal.toString()) ?? 0;
    final isNonStop = stopCount == 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header: logo + airline + flight no
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(6), child: _airlineLogo(airlineCode)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$airlineName',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  flightNumber.isEmpty ? '' : 'Flight $flightNumber',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // route row
            Row(
              children: [
                // departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(departTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(from, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(departDate, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),

                // middle: duration / stops
                Column(
                  children: [
                    Text(flightDuration, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                    const SizedBox(height: 6),
                    Icon(isNonStop ? Icons.flight_takeoff : Icons.flight, color: isNonStop ? Colors.green : Colors.orange),
                    const SizedBox(height: 6),
                    Text(isNonStop ? 'Non-stop' : '$stopCount stop${stopCount > 1 ? 's' : ''}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),

                // arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(arriveTime, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(to, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(arriveDate, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 22),

            // aircraft / baggage / class
            Wrap(
              runSpacing: 8,
              spacing: 12,
              children: [
                if (aircraft.isNotEmpty) _infoChip('Aircraft', aircraft, context),
                if (segment['CabinClass'] != null) _infoChip('Cabin', _safeStr(segment['CabinClass']), context),
                if (segment['BookingClass'] != null) _infoChip('Booking', _safeStr(segment['BookingClass']), context),
                if (baggage.isNotEmpty) _infoChip('Baggage', baggage, context),
                if (cabinBaggage.isNotEmpty) _infoChip('Cabin Bag', cabinBaggage, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$title: ', style: TextStyle(fontSize: 12, color: theme.hintColor)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: theme.textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _fareRow(String label, String amount, {bool isTotal = false, required BuildContext context}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontSize: isTotal ? 16 : 14, 
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            amount, 
            style: TextStyle(
              fontSize: isTotal ? 16 : 14, 
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, 
              color: isTotal ? theme.colorScheme.primary : theme.textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  void _printFlightData() {
    print('\n🛫 FLIGHT DETAILS DEBUG =====================');
    print('📦 Raw Flight Data:');
    flight.forEach((key, value) {
      print('   - $key: ${value?.toString() ?? 'null'} (${value?.runtimeType})');
    });
    
    // Print segments if they exist
    if (flight['segments'] != null && flight['segments'] is List) {
      print('\n📋 Segments:');
      for (var i = 0; i < flight['segments'].length; i++) {
        print('   Segment $i:');
        (flight['segments'][i] as Map).forEach((key, value) {
          print('      $key: ${value?.toString() ?? 'null'} (${value?.runtimeType})');
        });
      }
    } else {
      print('\n❌ No segments found in flight data');
    }
    
    // Check for common duration/time fields
    print('\n⏱️ Time/Duration Fields:');
    final timeFields = ['Duration', 'DurationTime', 'JourneyDuration', 'TravelTime', 'departureTime', 'arrivalTime', 'DepartureTime', 'ArrivalTime'];
    bool foundTimeField = false;
    
    // Check in main flight object
    timeFields.forEach((field) {
      if (flight[field] != null) {
        print('   ✅ Found $field: ${flight[field]}');
        foundTimeField = true;
      }
    });
    
    // Check in segments
    if (flight['segments'] is List) {
      for (var i = 0; i < flight['segments'].length; i++) {
        final segment = flight['segments'][i];
        timeFields.forEach((field) {
          if (segment[field] != null) {
            print('   ✅ Segment $i - $field: ${segment[field]}');
            foundTimeField = true;
          }
        });
      }
    }
    
    if (!foundTimeField) {
      print('   ❌ No time/duration fields found in flight data');
    }
    
    print('\n🔍 Search Params:');
    searchParams.forEach((key, value) {
      print('   - $key: $value');
    });
    print('========================================\n');
  }

  @override
  Widget build(BuildContext context) {
    // Print flight data for debugging - wrap in try/catch to prevent crashes
    try {
      _printFlightData();
    } catch (e) {
      print('❌ Error printing flight data: $e');
    }
    
    // Handle both old and new flight data structure
    final List<dynamic> flightSegments = (flight['segments'] is List) 
        ? flight['segments'] 
        : [flight]; // Fallback to using the flight object directly if no segments

    // try to extract price
    final offeredFareStr = flight['OfferedFare']?.toString() ?? 
                          flight['PublishedFare']?.toString() ?? 
                          flight['Price']?.toString() ?? 
                          flight['totalFare']?.toString() ?? 
                          '0';
    final offeredFare = double.tryParse(offeredFareStr) ?? 0.0;
    final formattedPrice = NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(offeredFare);

    // Determine origin/destination with fallbacks
    final from = _safeStr(
      searchParams['fromAirport'] ?? 
      flight['origin'] ?? 
      flight['Origin'] ?? 
      flight['From'] ?? 
      (flightSegments.isNotEmpty ? flightSegments.first['origin'] ?? flightSegments.first['Origin'] ?? flightSegments.first['From'] : '')
    );
    
    final to = _safeStr(
      searchParams['toAirport'] ?? 
      flight['destination'] ?? 
      flight['Destination'] ?? 
      flight['To'] ?? 
      (flightSegments.isNotEmpty ? flightSegments.last['destination'] ?? flightSegments.last['Destination'] ?? flightSegments.last['To'] : '')
    );
    final List<Map<String, dynamic>> segments = [];
    if (flight['Segments'] is List) {
      for (final s in flight['Segments']) {
        if (s is Map<String, dynamic>) {
          segments.add(s);
        } else if (s is Map) {
          segments.add(Map<String, dynamic>.from(s));
        }
      }
    }

    // If no explicit segments, but there are some top-level departure/arrival fields, build a single segment
    if (segments.isEmpty && (flight['DepartureTime'] != null || flight['ArrivalTime'] != null)) {
      segments.add({
        'AirlineName': flight['AirlineName'] ?? flight['airline'],
        'FlightNumber': flight['FlightNumber'] ?? flight['flightNumber'],
        'DepartureTime': flight['DepartureTime'],
        'ArrivalTime': flight['ArrivalTime'],
        'Origin': flight['Origin'] ?? from,
        'Destination': flight['Destination'] ?? to,
        'AircraftType': flight['AircraftType'] ?? '',
        'Baggage': flight['Baggage'] ?? '',
      });
    }

    // For round-trip, you may want to split segments by direction; here we show all segments sequentially
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Get.back(), color: Colors.black),
        title: const Text('Flight Details', style: TextStyle(color: Colors.black)),
        foregroundColor: Colors.black,

      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_safeStr(flight['AirlineName'] ?? flight['airline']), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(_safeStr(flight['FlightNumber'] ?? flight['flightNumber']), style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formattedPrice, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                      Text(_safeStr(flight['Currency'] ?? 'INR'), style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),

            // Segments list
            _sectionHeader(flightSegments.length > 1 ? 'Flight Segments' : 'Flight'),
            if (flightSegments.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No flight segment information available', 
                  style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic)),
              )
            else
              ...flightSegments.asMap().entries.map((e) => _buildSegmentCard(
                e.value is Map ? e.value : {'details': e.value},
                defaultFrom: from,
                defaultTo: to,
                segmentIndex: e.key,
                totalSegments: flightSegments.length,
                context: context,
              )),

            // Fare summary
            _sectionHeader('Fare Summary'),
            _fareRow('Base Fare', NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(offeredFare * 0.7), context: context),
            _fareRow('Taxes & Fees', NumberFormat.currency(symbol: '₹', decimalDigits: 2).format(offeredFare * 0.3), context: context),
            const Divider(),
            _fareRow('Total Amount', formattedPrice, isTotal: true, context: context),

            // Baggage info
            _sectionHeader('Baggage Information'),
            if (segments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text('No baggage information available', style: TextStyle(color: Colors.grey[700])),
              )
            else
              ...segments.map((s) {
                final cabin = _safeStr(s['CabinBaggage'] ?? s['HandBaggage'] ?? '7 kg');
                final checkin = _safeStr(s['CheckedBaggage'] ?? s['Baggage'] ?? '15 kg');
                final segFrom = _safeStr(s['Origin'] ?? s['From'] ?? from);
                final segTo = _safeStr(s['Destination'] ?? s['To'] ?? to);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$segFrom → $segTo', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cabin', style: TextStyle(color: Colors.grey[700])),
                          Text(cabin, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Check-in', style: TextStyle(color: Colors.grey[700])),
                          Text(checkin, style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              }).toList(),

            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to booking flow with full data
            Get.toNamed('/flight/booking', arguments: {'flight': flight, 'searchParams': searchParams});
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Book Now for $formattedPrice', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
