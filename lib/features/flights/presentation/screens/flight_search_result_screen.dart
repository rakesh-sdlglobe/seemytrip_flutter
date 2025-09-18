// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// // Helper method to format time
// String _formatTime(String dateTimeStr) {
//   try {
//     final dateTime = DateTime.parse(dateTimeStr);
//     return DateFormat('h:mm a').format(dateTime);
//   } catch (e) {
//     return dateTimeStr;
//   }
// }

// // Helper method to format date
// String _formatDate(String dateStr) {
//   try {
//     final date = DateTime.parse(dateStr);
//     return DateFormat('E, MMM d').format(date);
//   } catch (e) {
//     return dateStr;
//   }
// }

// class FlightSearchResultScreen extends StatelessWidget {
//   const FlightSearchResultScreen({
//     Key? key,
//     required this.flightType,
//     required this.flightData,
//     required this.searchParams,
//   }) : super(key: key);

//   final String flightType;
//   final Map<String, dynamic> flightData;
//   final Map<String, dynamic> searchParams;

//   // Getters for search parameters
//   String get fromAirport => searchParams['fromAirport'] ?? '';
//   String get toAirport => searchParams['toAirport'] ?? '';
//   String get departDate => searchParams['departDate'] ?? '';
//   String? get returnDate => searchParams['returnDate'];
//   int get adults => searchParams['adults'] ?? 1;
//   int get children => searchParams['children'] ?? 0;
//   int get infants => searchParams['infants'] ?? 0;
//   String get travelClass => searchParams['travelClass'] ?? 'Economy';

//   // Get flight results based on flight type
//   List<dynamic> get flightResults {
//     if (flightType == 'one-way' || flightType == 'O') {
//       return flightData['FlightResults'] ?? [];
//     } else if (flightType == 'round-trip' || flightType == 'R') {
//       return flightData['FlightGroupResults'] ?? [];
//     } else {
//       return [];
//     }
//   }

//   // Helper method to get airline logo
//   Widget _getAirlineLogo(String airlineCode) => Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.blue.shade100,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: Text(
//           airlineCode,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//             color: Colors.blue,
//           ),
//         ),
//       ),
//     );

//   // Helper method to build flight duration
//   Widget _buildFlightDuration(String duration) => Row(
//       children: [
//         const Icon(Icons.access_time, size: 16, color: Colors.grey),
//         const SizedBox(width: 4),
//         Text(
//           duration,
//           style: const TextStyle(color: Colors.grey, fontSize: 12),
//         ),
//       ],
//     );

//   // Helper method to build price
//   Widget _buildPrice(double price) => Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           '₹${price.toStringAsFixed(0)}',
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const Text(
//           'per person',
//           style: TextStyle(fontSize: 10, color: Colors.grey),
//         ),
//       ],
//     );

//   // Helper method to build flight card
//   Widget _buildFlightCard(dynamic flight) {
//     try {
//       // Safely extract segments with null checks
//       final segments = (flight?['Segments'] as List<dynamic>?) ?? [];
//       if (segments.isEmpty) return const SizedBox.shrink();

//       // Safely get first and last segments
//       final firstSegmentList = segments.firstOrNull?['Segments'] as List<dynamic>?;
//       final lastSegmentList = segments.lastOrNull?['Segments'] as List<dynamic>?;
      
//       if (firstSegmentList == null || firstSegmentList.isEmpty || 
//           lastSegmentList == null || lastSegmentList.isEmpty) {
//         return const SizedBox.shrink();
//       }
      
//       final firstSegment = firstSegmentList.firstOrNull;
//       final lastSegment = lastSegmentList.lastOrNull;

//       if (firstSegment == null || lastSegment == null) return const SizedBox.shrink();

//       return Card(
//         margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               // Airline and price row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _getAirlineLogo((flight?['flightCode']?.toString() ?? '')),
//                   _buildPrice(
//                     (flight?['OfferedFare'] != null) 
//                         ? (double.tryParse(flight!['OfferedFare'].toString()) ?? 0.0) 
//                         : 0.0
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Flight details row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Departure
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _formatTime((firstSegment['Origin']?['DepTime'] as String?) ?? ''),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         (firstSegment['Origin']?['Airport']?['AirportCode'] as String?) ?? '',
//                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   // Duration and stops
//                   Column(
//                     children: [
//                       _buildFlightDuration(segments.first['TotalDuraionTime']?.toString() ?? ''),
//                       const SizedBox(height: 4),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Text(
//                           '${flight['StopCount']} ${flight['StopCount'] == '0' ? 'Stop' : 'Stops'}',
//                           style: const TextStyle(fontSize: 10),
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Arrival
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         _formatTime((lastSegment['Destination']?['ArrTime'] as String?) ?? ''),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         (lastSegment['Destination']?['Airport']?['AirportCode'] as String?) ?? '',
//                         style: const TextStyle(fontSize: 12, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               // Flight number and details
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${flight['flightName'] ?? ''} • ${flight['flightCode'] ?? ''}${firstSegment['Airline']?['FlightNumber'] ?? ''}',
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                   Text(
//                     '${firstSegment['Baggage'] ?? ''} • ${firstSegment['CabinBaggage'] ?? ''}',
//                     style: const TextStyle(fontSize: 12, color: Colors.green),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint('Error building flight card: $e');
//       return const SizedBox.shrink();
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: Text('$flightType Flight Results'.toUpperCase()),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Search Summary Card
//           Card(
//             margin: EdgeInsets.zero,
//             elevation: 4,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(16),
//                 bottomRight: Radius.circular(16),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Route info
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'From',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             Text(
//                               fromAirport,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'To',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                             Text(
//                               toAirport,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           flightType.toUpperCase(),
//                           style: const TextStyle(
//                             color: Colors.blue,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Date and passengers
//                   const SizedBox(height: 12),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     crossAxisAlignment: WrapCrossAlignment.center,
//                     children: [
//                       const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
//                       Text(
//                         _formatDate(departDate),
//                         style: const TextStyle(color: Colors.grey, fontSize: 13),
//                       ),
//                       if (returnDate != null) ...[
//                         const Text('•', style: TextStyle(color: Colors.grey)),
//                         Text(
//                           _formatDate(returnDate!),
//                           style: const TextStyle(color: Colors.grey, fontSize: 13),
//                         ),
//                       ],
//                       const SizedBox(width: 8),
//                       const Icon(Icons.person_outline, size: 14, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         '$adults Adult${adults > 1 ? 's' : ''}',
//                         style: const TextStyle(color: Colors.grey, fontSize: 13),
//                       ),
//                       if (children > 0) ...[
//                         const Text('•', style: TextStyle(color: Colors.grey)),
//                         Text(
//                           '$children Child${children > 1 ? 'ren' : ''}',
//                           style: const TextStyle(color: Colors.grey, fontSize: 13),
//                         ),
//                       ],
//                       if (infants > 0) ...[
//                         const Text('•', style: TextStyle(color: Colors.grey)),
//                         Text(
//                           '$infants Infant${infants > 1 ? 's' : ''}',
//                           style: const TextStyle(color: Colors.grey, fontSize: 13),
//                         ),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Class
//                   Row(
//                     children: [
//                       const Icon(Icons.airline_seat_recline_normal, size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         travelClass,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Results count
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 const Text(
//                   'Available Flights',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.shade50,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     '${flightResults.length} ${flightResults.length == 1 ? 'result' : 'results'}',
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Flight Results List
//           Expanded(
//             child: flightResults.isEmpty
//                 ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(32.0),
//                       child: Text(
//                         'No flights found for the selected criteria.',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     itemCount: flightResults.length,
//                     itemBuilder: (context, index) {
//                       final flight = flightResults[index];
//                       return _buildFlightCard(flight);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
// }