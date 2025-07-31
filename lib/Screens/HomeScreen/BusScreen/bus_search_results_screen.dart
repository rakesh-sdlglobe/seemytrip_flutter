import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:seemytrip/Constants/colors.dart';

// Models and Controllers
import 'package:seemytrip/Models/bus_models.dart' show BusSearchResult;
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_home_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/widgets/bus_filter_screen.dart';
import 'package:seemytrip/Controller/bus_controller.dart';
import 'bus_seat_layout_screen.dart';

// --- RED THEME COLORS ---
const Color kPrimaryColor = Color(0xFFD32F2F);
const Color kPrimaryDarkColor = Color(0xFFB71C1C);
const Color kPrimaryLightColor = Color(0xFFFFEBEE);
const Color kTextPrimaryColor = Color(0xFF212529);
const Color kTextSecondaryColor = Color(0xFF6C757D);
const Color kScaffoldBackgroundColor = Color.fromARGB(255, 219, 222, 230);
const Color kCardBackground = Color(0xFFFFFFFF);
const Color kSuccessColor = Color(0xFF28A745);
const Color kDividerColor = Color(0xFFE9ECEF);
const Color kChipBackground = Color(0xFFFDE8E8);

// Arguments class remains the same
class BusSearchResultsScreenArguments {
  final List<BusSearchResult> results;
  final String fromLocation;
  final String toLocation;
  final DateTime? travelDate;

  BusSearchResultsScreenArguments({
    required this.results,
    required this.fromLocation,
    required this.toLocation,
    this.travelDate,
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _allResults = List.from(widget.args.results);
    _allResults.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    displayedResults = List.from(_allResults);
  }

  void _applyFilteredResults(List<BusSearchResult> filteredResults) {
    setState(() {
      displayedResults = filteredResults;
    });
  }

  void _openFilterSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return BusFilterScreen(
              results: _allResults,
              scrollController: controller,
              onApplyFilters: _applyFilteredResults,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: _buildModernAppBar(),
      body: Stack(
        children: [
          if (displayedResults.isEmpty)
            _buildEmptyState()
          else
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              itemCount: displayedResults.length,
              itemBuilder: (context, index) {
                final result = displayedResults[index];
                return _buildBusCard(result);
              },
            ),
          _buildSortFilterButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      // backgroundColor: kCardBackground,
      backgroundColor: redCA0,
      foregroundColor: Colors.white,
      toolbarHeight: 80,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kScaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kTextPrimaryColor, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      titleSpacing: 0,

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${widget.args.fromLocation} → ${widget.args.toLocation}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: () => Get.to(BusHomeScreen()),
              ),
            ],
          ),
          Text(
            DateFormat('EEEE, d MMM yyyy')
                .format(widget.args.travelDate ?? DateTime.now()),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: kDividerColor,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildBusCard(BusSearchResult result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {/* Navigation logic */},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardHeader(result),
                const SizedBox(height: 20),
                Container(height: 1, color: kDividerColor),
                const SizedBox(height: 20),
                // --- RESPONSIVE LAYOUT BUILDER ---
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Use a vertical layout on very narrow screens
                    if (constraints.maxWidth < 350) {
                      return _buildVerticalTripDetails(result);
                    }
                    // Use a horizontal layout on wider screens
                    return _buildHorizontalTripDetails(result);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(BusSearchResult result) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.directions_bus_rounded,
              color: kPrimaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.busOperatorName,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: kTextPrimaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: kChipBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result.busType,
                      style: GoogleFonts.poppins(
                        color: kPrimaryDarkColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kSuccessColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded,
                        color: kSuccessColor, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      "4.2",
                      style: GoogleFonts.poppins(
                        color: kSuccessColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Layout for wider screens.
  Widget _buildHorizontalTripDetails(BusSearchResult result) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3, // Give more space to the timeline
          child: _buildTimeline(result),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2, // Give less space to the price
          child: _buildFareAndButton(result),
        ),
      ],
    );
  }

  /// Layout for narrower screens.
  Widget _buildVerticalTripDetails(BusSearchResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeline(result),
        const SizedBox(height: 20),
        _buildFareAndButton(result,
            crossAxisAlignment: CrossAxisAlignment.start),
      ],
    );
  }

  /// Common widget for fare and the select seats button.
  Widget _buildFareAndButton(BusSearchResult result,
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.end}) {
    bool isLoading = false;
    return Column(crossAxisAlignment: crossAxisAlignment, children: [
      Text(
        '₹${result.fare}',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: kPrimaryDarkColor,
        ),
      ),
      Text(
        '/seat',
        style: GoogleFonts.poppins(
          color: kTextSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimaryColor, kPrimaryDarkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
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

                if (seatLayout != null) {
                  Get.to(() => BusSeatLayoutScreen(
                        args: BusSeatLayoutScreenArguments(
                          traceId: result.traceId ?? '',
                          resultIndex: result.resultIndex ?? 0,
                          fromLocation: widget.args.fromLocation,
                          toLocation: widget.args.toLocation,
                          travelDate: widget.args.travelDate ?? DateTime.now(),
                          busName: result.busOperatorName,
                          // --- ADD THIS LINE ---

                          availableSeats: result.availableSeats,
                        ),
                      ));
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
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Select Seats',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    ]);
  }

  Widget _buildTimeline(BusSearchResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineRow(
          icon: Icons.radio_button_checked,
          iconColor: kPrimaryColor,
          time: _formatTime(result.departureTime),
          location: widget.args.fromLocation,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, top: 4, bottom: 4),
          child: DottedLine(
            direction: Axis.vertical,
            lineLength: 30,
            lineThickness: 1.8,
            dashColor: kTextSecondaryColor.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(result.duration,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 3, top: 4, bottom: 4),
          child: DottedLine(
            direction: Axis.vertical,
            lineLength: 30,
            lineThickness: 1.8,
            dashColor: kTextSecondaryColor.withOpacity(0.3),
          ),
        ),
        _buildTimelineRow(
          icon: Icons.location_on,
          iconColor: kSuccessColor,
          time: _formatTime(result.arrivalTime),
          location: widget.args.toLocation,
        ),
      ],
    );
  }

  Widget _buildTimelineRow(
      {required IconData icon,
      required Color iconColor,
      required String time,
      required String location}) {
    return Row(
      children: [
        Icon(icon, size: 10, color: iconColor),
        const SizedBox(width: 10),
        Text(
          time,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: kTextPrimaryColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            location,
            style: GoogleFonts.poppins(
              color: kTextPrimaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_bus_outlined,
                  size: 60, color: kPrimaryColor),
            ),
            const SizedBox(height: 24),
            Text(
              'No Buses Found',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We couldn\'t find any buses for this route. Try adjusting your filters or searching for a different date.',
              style: GoogleFonts.poppins(
                  fontSize: 15, color: kTextSecondaryColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortFilterButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kPrimaryDarkColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _openFilterSortSheet,
          icon: const Icon(Icons.tune_rounded, size: 20),
          label: Text('Sort & Filter',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 16)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
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
