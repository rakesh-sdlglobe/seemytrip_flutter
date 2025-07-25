import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/Models/bus_models.dart' show BusSearchResult;
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/bus_filter_screen.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/bus_controller.dart';
import 'bus_seat_layout_screen.dart';

class BusSearchResultsScreenArguments {
  final List<BusSearchResult> results;
  final String fromLocation;
  final String toLocation;
  final DateTime? travelDate;
  final int? seatCount;

  BusSearchResultsScreenArguments({
    required this.results,
    required this.fromLocation,
    required this.toLocation,
    this.travelDate,
    this.seatCount,
  });
}

class BusSearchResultsScreen extends StatefulWidget {
  final BusSearchResultsScreenArguments args;

  const BusSearchResultsScreen({Key? key, required this.args})
      : super(key: key);

  @override
  State<BusSearchResultsScreen> createState() => _BusSearchResultsScreenState();
}

class _BusSearchResultsScreenState extends State<BusSearchResultsScreen> {
  List<BusSearchResult> _allResults = [];
  List<BusSearchResult> displayedResults = [];
  String _currentSort = 'Fare (Low to High)';

  @override
  void initState() {
    super.initState();
    _allResults = List.from(widget.args.results);
    displayedResults = List.from(_allResults);
    _sortResults();
  }

  void _sortResults() {
    setState(() {
      if (_currentSort == 'Fare (Low to High)') {
        displayedResults.sort(
            (a, b) => double.parse(a.fare).compareTo(double.parse(b.fare)));
      } else if (_currentSort == 'Fare (High to Low)') {
        displayedResults.sort(
            (a, b) => double.parse(b.fare).compareTo(double.parse(a.fare)));
      } else if (_currentSort == 'Departure Time') {
        displayedResults
            .sort((a, b) => a.departureTime.compareTo(b.departureTime));
      } else if (_currentSort == 'Arrival Time') {
        displayedResults.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
      } else if (_currentSort == 'Seats Available') {
        displayedResults
            .sort((a, b) => b.availableSeats.compareTo(a.availableSeats));
      }
    });
  }

  void _openFilterSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BusFilterScreen(
          results: _allResults,
          onApplyFilters: (filteredResults) {
            setState(() {
              displayedResults = filteredResults;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fromLocation = widget.args.fromLocation ?? 'Origin';
    final toLocation = widget.args.toLocation ?? 'Destination';
    final travelDate = widget.args.travelDate ?? DateTime.now();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$fromLocation → $toLocation',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('EEEE, d MMM yyyy').format(travelDate),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            onPressed: _openFilterSortSheet,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: displayedResults.isEmpty
                ? const Center(
                    child: Text(
                      'No buses found for this route',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: displayedResults.length,
                    itemBuilder: (context, index) {
                      final result = displayedResults[index];
                      return _buildBusCard(result, theme);
                    },
                  ),
          ),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildBusCard(BusSearchResult result, ThemeData theme) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: InkWell(
        onTap: () async {
          final busController = Get.find<BusController>();
          try {
            final seatLayout = await busController.getBusSeatLayout(
              result.traceId,
              result.resultIndex,
            );

            if (seatLayout != null) {
              // Navigate to seat selection screen with the seat layout data
              // Ensure we have all required values before navigating
              final traceId = result.traceId ?? '';
              final resultIndex = result.resultIndex ?? 0;
              final fromLocation = widget.args.fromLocation;
              final toLocation = widget.args.toLocation;
              final travelDate = widget.args.travelDate;
              final busName = result.busOperatorName;

              if (traceId.isNotEmpty) {
                Get.to(
                  () => BusSeatLayoutScreen(
                    args: BusSeatLayoutScreenArguments(
                      traceId: traceId,
                      resultIndex: resultIndex,
                      fromLocation: fromLocation,
                      toLocation: toLocation,
                      travelDate: travelDate ?? DateTime.now(),
                      busName: busName,
                    ),
                  ),
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Could not load seat layout. Missing required information.',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                );
              }
            }
          } catch (e) {
            print('Error fetching seat layout: $e');
            Get.snackbar(
              'Error',
              'Failed to load seat layout',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: redCA0.withOpacity(0.1),
                    child: Icon(Icons.directions_bus, color: redCA0),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.busOperatorName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          result.busType,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: redCA0, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '4.2',
                          style: TextStyle(
                            color: redCA0,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(result.departureTime),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          result.duration,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Divider(
                          color: Colors.grey[300],
                          height: 2,
                          thickness: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(result.arrivalTime),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${result.fare}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.primaryColor,
                        ),
                      ),
                      const Text(
                        'per seat',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_seat, size: 16, color: redCA0),
                        const SizedBox(width: 4),
                        Text(
                          '${result.availableSeats} Seats',
                          style: TextStyle(
                            color: redCA0,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${result.busNumber}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View Details',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _openFilterSortSheet,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sort, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Sort & Filters',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String timeStr) {
    try {
      final parsed = DateFormat('HH:mm:ss').parse(timeStr);
      return DateFormat('hh:mm a').format(parsed);
    } catch (e) {
      return timeStr;
    }
  }
}
