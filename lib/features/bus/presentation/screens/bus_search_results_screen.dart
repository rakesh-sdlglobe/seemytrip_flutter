import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../shared/models/bus_models.dart';
import '../controllers/bus_controller.dart';
import '../widgets/bus_filter_screen.dart';
import 'bus_home_screen.dart';
import 'bus_seat_layout_screen.dart' show BusSeatLayoutScreen, BusSeatLayoutScreenArguments;

// Theme colors will be accessed through Theme.of(context) instead of hardcoded constants

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
  bool _isInitialLoading = true;
  int? _loadingButtonIndex;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimations();
  }

  Future<void> _initializeData() async {
    // Simulate initial loading for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _allResults = List.from(widget.args.results);
        _allResults.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        displayedResults = List.from(_allResults);
        _isInitialLoading = false;
      });
      _animationController?.forward();
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOutCubic,
    ));
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

  Future<void> _loadSeatLayout(BusSearchResult result, int index) async {
    setState(() => _loadingButtonIndex = index);
    final busController = Get.find<BusController>();
    try {
      final seatLayout = await busController.getBusSeatLayout(
        result.traceId,
        result.resultIndex,
      );

      if (seatLayout != null && mounted) {
        Get.to(() => BusSeatLayoutScreen(
              args: BusSeatLayoutScreenArguments(
                traceId: result.traceId,
                resultIndex: result.resultIndex,
                fromLocation: widget.args.fromLocation,
                toLocation: widget.args.toLocation,
                travelDate: widget.args.travelDate ?? DateTime.now(),
                busName: result.busOperatorName,
                availableSeats: result.availableSeats,
                departureTime: result.departureTime,
                arrivalTime: result.arrivalTime,
              ),
            ));
      } else if (mounted) {
        Get.snackbar(
          'Error',
          'Could not load seat layout.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.redCA0,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to load seat layout: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.redCA0,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingButtonIndex = null);
      }
    }
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
            color: Theme.of(context).scaffoldBackgroundColor,
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildModernAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : AppColors.redF9E.withOpacity(0.03),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _isInitialLoading
                ? _buildShimmerLoading()
                : _fadeAnimation == null || _animationController == null
                    ? _buildShimmerLoading()
                    : FadeTransition(
                        opacity: _fadeAnimation!,
                        child: SlideTransition(
                          position: _slideAnimation!,
                          child: displayedResults.isEmpty
                              ? _buildEmptyState()
                              : Column(
                                  children: [
                                    _buildResultsHeader(),
                                    Expanded(
                                      child: RefreshIndicator(
                                        onRefresh: () async {
                                          await Future.delayed(const Duration(seconds: 1));
                                          setState(() {
                                            displayedResults = List.from(_allResults);
                                          });
                                        },
                                        color: AppColors.redCA0,
                                        child: ListView.builder(
                                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 200),
                                          physics: const AlwaysScrollableScrollPhysics(),
                                          itemCount: displayedResults.length,
                                          itemBuilder: (context, index) {
                                            final result = displayedResults[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 16.0),
                                              child: _buildBusCard(result, index),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
            if (!_isInitialLoading && displayedResults.isNotEmpty) _buildSortFilterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsHeader() => Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.redCA0.withOpacity(0.1),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.redCA0.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redCA0.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.directions_bus_rounded, size: 18, color: AppColors.redCA0),
                  const SizedBox(width: 8),
                  Text(
                    '${displayedResults.length} ${displayedResults.length == 1 ? 'Bus' : 'Buses'} Found',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.redCA0,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  PreferredSizeWidget _buildModernAppBar() => AppBar(
        backgroundColor: AppColors.redCA0,
        foregroundColor: Colors.white,
        toolbarHeight: 85,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            onPressed: () => Get.back(),
          ),
        ),
        titleSpacing: 0,
        title: Container(
          padding: const EdgeInsets.only(right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${widget.args.fromLocation} → ${widget.args.toLocation}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                      onPressed: () => Get.to(() => const BusHomeScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white.withOpacity(0.9)),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('EEEE, d MMM yyyy').format(widget.args.travelDate ?? DateTime.now()),
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: 4,
          ),
        ),
      );

  Widget _buildBusCard(BusSearchResult result, int index) {
    final isButtonLoading = _loadingButtonIndex == index;
    
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50).toInt()),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.5)
                        : AppColors.redCA0.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  splashColor: AppColors.redCA0.withOpacity(0.1),
                  highlightColor: AppColors.redCA0.withOpacity(0.05),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCardHeader(result),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Theme.of(context).dividerColor.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 360) {
                              return _buildVerticalTripDetails(result, index, isButtonLoading);
                            }
                            return _buildHorizontalTripDetails(result, index, isButtonLoading);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardHeader(BusSearchResult result) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.redCA0, AppColors.redCA0.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.redCA0.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.directions_bus_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.busOperatorName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                    height: 1.3,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.redF9E, AppColors.redF9E.withOpacity(0.8)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: AppColors.redCA0.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.redCA0.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          result.busType.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: AppColors.redCA0,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.green00A.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.green00A.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_rounded, color: AppColors.green00A, size: 13),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '4.2',
                                style: GoogleFonts.poppins(
                                  color: AppColors.green00A,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.availableSeats} Seats Available',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildHorizontalTripDetails(BusSearchResult result, int index, bool isButtonLoading) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildTimeline(result),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _buildFareAndButton(result, index, isButtonLoading),
          ),
        ],
      );

  Widget _buildVerticalTripDetails(BusSearchResult result, int index, bool isButtonLoading) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeline(result),
          const SizedBox(height: 16),
          _buildFareAndButton(result, index, isButtonLoading, crossAxisAlignment: CrossAxisAlignment.start),
        ],
      );

  Widget _buildFareAndButton(
    BusSearchResult result,
    int index,
    bool isButtonLoading, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.end,
  }) =>
      Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.redF9E.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.redCA0.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: AppColors.redCA0,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      '${result.fare}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: AppColors.redCA0,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'per seat',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.redCA0, AppColors.redCA0.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.redCA0.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.redCA0.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isButtonLoading ? null : () => _loadSeatLayout(result, index),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: crossAxisAlignment == CrossAxisAlignment.end
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (isButtonLoading)
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.event_seat_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Select Seats',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildTimeline(BusSearchResult result) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineRow(
            icon: Icons.circle,
            iconColor: AppColors.redCA0,
            time: _formatTime(result.departureTime),
            location: widget.args.fromLocation,
            isDeparture: true,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 40,
              lineThickness: 2.5,
              dashColor: AppColors.redCA0.withOpacity(0.3),
              dashGapLength: 4,
              dashRadius: 2,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 18),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.orangeFFB.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.orangeFFB.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_rounded, size: 14, color: AppColors.orangeFFB),
                const SizedBox(width: 6),
                Text(
                  result.duration,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.orangeFFB,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
            child: DottedLine(
              direction: Axis.vertical,
              lineLength: 40,
              lineThickness: 2.5,
              dashColor: AppColors.green00A.withOpacity(0.3),
              dashGapLength: 4,
              dashRadius: 2,
            ),
          ),
          _buildTimelineRow(
            icon: Icons.location_on_rounded,
            iconColor: AppColors.green00A,
            time: _formatTime(result.arrivalTime),
            location: widget.args.toLocation,
            isDeparture: false,
          ),
        ],
      );

  Widget _buildTimelineRow({
    required IconData icon,
    required Color iconColor,
    required String time,
    required String location,
    bool isDeparture = true,
  }) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: iconColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(icon, size: 12, color: iconColor),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildEmptyState() => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.redF9E, AppColors.redF9E.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.redCA0.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.directions_bus_outlined,
                  size: 60,
                  color: AppColors.redCA0,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'No Buses Found',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black2E2,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We couldn\'t find any buses for this route.\nTry adjusting your filters or searching for a different date.',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.grey717,
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.redCA0.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => const BusHomeScreen()),
                  icon: const Icon(Icons.search_rounded, size: 20),
                  label: Text(
                    'Modify Search',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redCA0,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildShimmerLoading() => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
        itemCount: 3,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildShimmerCard(),
        ),
      );

  Widget _buildShimmerCard() => Container(
        margin: const EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : AppColors.redCA0.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]!
              : Colors.grey[300]!,
          highlightColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[700]!
              : Colors.grey[100]!,
          period: const Duration(milliseconds: 1200),
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 80,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 70,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                width: 70,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            margin: const EdgeInsets.only(left: 38),
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Container(
                                width: 70,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 90,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildSortFilterButton() => Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.98),
                Theme.of(context).scaffoldBackgroundColor,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.redCA0, AppColors.redCA0.withOpacity(0.95)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.redCA0.withOpacity(0.45),
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.redCA0.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _openFilterSortSheet,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(Icons.tune_rounded, size: 24, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Sort & Filter',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w800,
                              fontSize: 19,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            child: Text(
                              '${displayedResults.length}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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