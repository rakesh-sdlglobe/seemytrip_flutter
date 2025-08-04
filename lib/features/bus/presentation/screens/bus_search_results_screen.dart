import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/common/cards/app_card.dart';
import '../../../../core/utils/colors.dart';
import '../../../../shared/models/bus_models.dart';
import '../controllers/bus_controller.dart';
import '../widgets/bus_filter_screen.dart';
import 'bus_home_screen.dart';
import 'bus_seat_layout_screen.dart';

// --- REFINED THEME COLORS ---
const Color kPrimaryColor = Color(0xFFE53935);
const Color kPrimaryDarkColor = Color(0xFFC62828);
const Color kPrimaryLightColor = Color(0xFFFFEBEE);
const Color kTextPrimaryColor = Color(0xFF1A1A1A);
const Color kTextSecondaryColor = Color(0xFF757575);
const Color kScaffoldBackgroundColor = Color(0xFFF5F6FA);
const Color kCardBackground = Color(0xFFFFFFFF);
const Color kSuccessColor = Color(0xFF2ECC71);
const Color kDividerColor = Color(0xFFE0E0E0);
const Color kChipBackground = Color(0xFFFFE6E6);
const Color kAccentColor = Color(0xFFFFA726);

class BusSearchResultsScreenArguments {
  BusSearchResultsScreenArguments({
    required this.results,
    required this.fromLocation,
    required this.toLocation,
    this.travelDate,
  });
  final List<BusSearchResult> results;
  final String fromLocation;
  final String toLocation;
  final DateTime? travelDate;
}

class BusSearchResultsScreen extends StatefulWidget {
  const BusSearchResultsScreen({required this.args, super.key});
  final BusSearchResultsScreenArguments args;

  @override
  State<BusSearchResultsScreen> createState() => _BusSearchResultsScreenState();
}

class _BusSearchResultsScreenState extends State<BusSearchResultsScreen> with SingleTickerProviderStateMixin {
  List<BusSearchResult> _allResults = <BusSearchResult>[];
  List<BusSearchResult> displayedResults = <BusSearchResult>[];
  bool _isLoading = false;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _allResults = List.from(widget.args.results);
    _allResults.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    displayedResults = List.from(_allResults);

    // Initialize animation controller and fade animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _applyFilteredResults(List<BusSearchResult> filteredResults) {
    setState(() {
      displayedResults = filteredResults;
      _animationController?.reset();
      _animationController?.forward();
    });
  }

  void _openFilterSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: kScaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BusFilterScreen(
            results: _allResults,
            scrollController: controller,
            onApplyFilters: _applyFilteredResults,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure animation is initialized before building
    if (_fadeAnimation == null || _animationController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      appBar: _buildModernAppBar(),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation!,
            child: displayedResults.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    itemCount: displayedResults.length,
                    itemBuilder: (context, index) {
                      final result = displayedResults[index];
                      return _buildBusCard(result, index);
                    },
                  ),
          ),
          _buildSortFilterButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildModernAppBar() => AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        toolbarHeight: 90,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kTextPrimaryColor, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.args.fromLocation} → ${widget.args.toLocation}',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 22),
                  onPressed: () => Get.to(() => const BusHomeScreen()),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, d MMM yyyy').format(widget.args.travelDate ?? DateTime.now()),
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: kDividerColor.withOpacity(0.5),
            height: 1,
          ),
        ),
      );

  Widget _buildBusCard(BusSearchResult result, int index) => FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _animationController!,
            curve: Interval(0.1 * index, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: kCardBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardHeader(result),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      color: kDividerColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < 360) {
                          return _buildVerticalTripDetails(result);
                        }
                        return _buildHorizontalTripDetails(result);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildCardHeader(BusSearchResult result) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: kPrimaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.busOperatorName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: kTextPrimaryColor,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kChipBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    result.busType.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: kPrimaryDarkColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: kSuccessColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded, color: kSuccessColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '4.2',
                            style: GoogleFonts.poppins(
                              color: kSuccessColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(128 Reviews)',
                      style: GoogleFonts.poppins(
                        color: kTextSecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildHorizontalTripDetails(BusSearchResult result) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildTimeline(result),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _buildFareAndButton(result),
          ),
        ],
      );

  Widget _buildVerticalTripDetails(BusSearchResult result) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeline(result),
          const SizedBox(height: 20),
          _buildFareAndButton(result, crossAxisAlignment: CrossAxisAlignment.start),
        ],
      );

  Widget _buildFareAndButton(BusSearchResult result, {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.end}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '₹${result.fare}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: kPrimaryDarkColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/seat',
              style: GoogleFonts.poppins(
                color: kTextSecondaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () async {
              setState(() => _isLoading = true);
              final busController = Get.find<BusController>();
              try {
                final seatLayout = await busController.getBusSeatLayout(
                  result.traceId,
                  result.resultIndex,
                );

                if (seatLayout != null) {
                  Get.to(() => BusSeatLayoutScreen(
                        args: BusSeatLayoutScreenArguments(
                          traceId: result.traceId ?? '',
                          resultIndex: result.resultIndex ?? 0,
                          fromLocation: widget.args.fromLocation,
                          toLocation: widget.args.toLocation,
                          travelDate: widget.args.travelDate ?? DateTime.now(),
                          busName: result.busOperatorName,
                          availableSeats: result.availableSeats,
                        ),
                      ));
                } else {
                  Get.snackbar(
                    'Error',
                    'Could not load seat layout.',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 3),
                    backgroundColor: kPrimaryDarkColor,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to load seat layout',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                  backgroundColor: kPrimaryDarkColor,
                  colorText: Colors.white,
                );
              } finally {
                setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Select Seats',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BusSearchResult result) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineRow(
            icon: Icons.radio_button_checked,
            iconColor: kPrimaryColor,
            time: _formatTime(result.departureTime),
            location: widget.args.fromLocation,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.5, top: 6, bottom: 6),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 32,
              lineThickness: 2,
              dashColor: kTextSecondaryColor.withOpacity(0.4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              result.duration,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: kAccentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.5, top: 6, bottom: 6),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 32,
              lineThickness: 2,
              dashColor: kTextSecondaryColor.withOpacity(0.4),
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

  Widget _buildTimelineRow({
    required IconData icon,
    required Color iconColor,
    required String time,
    required String location,
  }) =>
      Row(
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 12),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kTextPrimaryColor,
            ),
          ),
          const SizedBox(width: 16),
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

  Widget _buildEmptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_bus_outlined,
                  size: 50,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Buses Found',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'We couldn’t find any buses for this route. Try adjusting your filters or searching for a different date.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: kTextSecondaryColor,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => Get.to(() => const BusHomeScreen()),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: kPrimaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Modify Search',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSortFilterButton() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _openFilterSortSheet,
            icon: const Icon(Icons.tune_rounded, size: 22, color: Colors.white),
            label: Text(
              'Sort & Filter',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
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

  String _formatTime(String timeStr) {
    try {
      final parsed = DateFormat('HH:mm:ss').parse(timeStr);
      return DateFormat('hh:mm a').format(parsed);
    } catch (e) {
      return timeStr;
    }
  }
}