import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:seemytrip/core/theme/app_colors.dart' as AppTheme;
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/helpers/date_time_helper.dart';
import '../../../../shared/models/bus_models.dart';
import '../controllers/bus_controller.dart';
import '../widgets/boarding_journey_summary.dart';
import '../widgets/boarding_point_list.dart';

import 'bus_passenger_details_screen.dart';
import 'bus_seat_layout_screen.dart';

class BoardingPointScreen extends StatefulWidget {
  final String? traceId;
  final int? resultIndex;
  final String? busName;
  final String? fromCity;
  final String? toCity;
  final String? journeyDate;
  final String? departureTime;
  final String? arrivalTime;
  final String? duration;
  final String? fare;
  final List<dynamic>? selectedSeats;

  const BoardingPointScreen({
    super.key,
    this.traceId,
    this.resultIndex,
    this.busName,
    this.fromCity,
    this.toCity,
    this.journeyDate,
    this.departureTime,
    this.arrivalTime,
    this.duration,
    this.fare,
    this.selectedSeats,
  }) : super();

  @override
  State<BoardingPointScreen> createState() => _BoardingPointScreenState();
}

class _BoardingPointScreenState extends State<BoardingPointScreen>
    with TickerProviderStateMixin {
  final BusController _busController = Get.find<BusController>();
  BoardingPoint? _selectedBoardingPoint;
  BoardingPoint? _selectedDroppingPoint;

  late final TabController _tabController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  bool _isMapReady = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
        setState(() {
          // _animateToSelectedPoint();
        });
      } else if (_tabController.index != _tabController.previousIndex) {
        setState(() {
          // Rebuild when tab changes to update selected point card
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPoints();
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  Future<void> _loadPoints() async {
    if (widget.traceId == null || widget.resultIndex == null) {
      debugPrint('Error: traceId or resultIndex is null.');
      if (mounted) {
        Get.snackbar('Error',
            'Could not load boarding points. Missing required information.',
            snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }

    try {
      final BoardingPointResponse? response =
          await _busController.getBoardingPoints(
        traceId: widget.traceId!,
        resultIndex: widget.resultIndex!,
      );

      if (mounted) {
        if (response != null) {
          debugPrint('Boarding Points: ${response.boardingPoints.length}');
          debugPrint('Dropping Points: ${response.droppingPoints.length}');

          setState(() {
            if (response.boardingPoints.isNotEmpty) {
              final firstPoint = response.boardingPoints.first;
              debugPrint(
                  'First Point: ${firstPoint.name} (${firstPoint.latitude}, ${firstPoint.longitude})');
              _selectedBoardingPoint = response.boardingPoints.firstWhere(
                (BoardingPoint p) => p.isDefault,
                orElse: () => response.boardingPoints.first,
              );
              _isMapReady = true;
            } else {
              debugPrint('No boarding points found');
              _isMapReady =
                  true; // Set ready even if empty so we don't shimmer forever
            }

            if (response.droppingPoints.isNotEmpty) {
              _selectedDroppingPoint = response.droppingPoints.firstWhere(
                (BoardingPoint p) => p.isDefault,
                orElse: () => response.droppingPoints.first,
              );
            }

            _isLoading = false;
          });
          _animationController.forward();
        } else {
          debugPrint('BoardingPointResponse is null');
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading points: $e');
      if (mounted) {
        Get.snackbar('Error', 'Failed to load points.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Journey Summary Card
              BoardingJourneySummary(
                busName: widget.busName ?? 'Unknown Bus',
                fromCity: widget.fromCity ?? 'Unknown',
                toCity: widget.toCity ?? 'Unknown',
              ),
              // Map View - Removed as per user request
              // BoardingPointMap(
              //   mapController: _mapController,
              //   center: _mapCenter,
              //   markers: _tabController.index == 0
              //       ? _boardingMarkers
              //       : _droppingMarkers,
              //   isReady: _isMapReady,
              // ),
              // Tab Bar
              _buildTabBar(),
              // Points List
              Expanded(
                child: _buildPointsContent(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildContinueButton(),
      );

  PreferredSizeWidget _buildAppBar() => AppBar(
        backgroundColor: AppTheme.AppColors.redCA0,
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
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Text(
          'Boarding & Dropping',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
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

  Widget _buildPointsContent() {
    // Check local state first - these use setState for updates, so no Obx needed
    if (_isLoading || !_isMapReady) {
      return _buildShimmerLoading();
    }

    // Use Obx only for observable controller values
    // Only access .value properties of observables inside Obx
    return Obx(() {
      // Only observable values are accessed here
      final bool isLoading = _busController.isLoading.value;
      final BoardingPointResponse? response =
          _busController.boardingPointsResponse.value;

      // Show loading if controller is loading (reactive update)
      if (isLoading) {
        return _buildShimmerLoading();
      }

      if (response == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off_outlined,
                size: 64,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No points available',
                style: GoogleFonts.poppins(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return TabBarView(
        key: const ValueKey('boarding_dropping_view'),
        controller: _tabController,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          BoardingPointList(
            points: response.boardingPoints,
            selectedPoint: _selectedBoardingPoint,
            onPointSelected: (point) {
              setState(() {
                _selectedBoardingPoint = point;
                // _animateToSelectedPoint();
                // Update markers to highlight selected
                // if (_busController.boardingPointsResponse.value != null) {
                //   _updateAllMarkers(
                //       _busController.boardingPointsResponse.value!);
                // }
              });
            },
            accentColor: AppTheme.AppColors.redCA0,
          ),
          BoardingPointList(
            points: response.droppingPoints,
            selectedPoint: _selectedDroppingPoint,
            onPointSelected: (point) {
              setState(() {
                _selectedDroppingPoint = point;
                // _animateToSelectedPoint();
                // Update markers to highlight selected
                // if (_busController.boardingPointsResponse.value != null) {
                //   _updateAllMarkers(
                //       _busController.boardingPointsResponse.value!);
                // }
              });
            },
            accentColor: AppTheme.AppColors.redCA0,
          ),
        ],
      );
    });
  }

  Widget _buildTabBar() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TabBar(
          key: const ValueKey('boarding_dropping_tabs'),
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: AppTheme.AppColors.redCA0,
          indicator: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.AppColors.redCA0,
                AppTheme.AppColors.redCA0.withOpacity(0.9)
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
          labelPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabs: const <Widget>[
            Tab(text: 'BOARDING'),
            Tab(text: 'DROPPING'),
          ],
        ),
      );

  Widget _buildShimmerLoading() => Shimmer.fromColors(
        baseColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]!
            : Colors.grey[300]!,
        highlightColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[700]!
            : Colors.grey[100]!,
        period: const Duration(milliseconds: 1200),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          itemBuilder: (context, index) => Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );

  Widget _buildContinueButton() => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : AppTheme.AppColors.redF9E.withOpacity(0.1),
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.15),
              blurRadius: 25,
              spreadRadius: 0,
              offset: const Offset(0, -8),
            ),
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (_selectedBoardingPoint != null ||
                _selectedDroppingPoint != null)
              Row(
                children: <Widget>[
                  if (_selectedBoardingPoint != null)
                    Expanded(
                        child: _buildSelectedPointCard(
                            'Boarding',
                            _selectedBoardingPoint!,
                            AppTheme.AppColors.redCA0)),
                  if (_selectedBoardingPoint != null &&
                      _selectedDroppingPoint != null)
                    const SizedBox(width: 12),
                  if (_selectedDroppingPoint != null)
                    Expanded(
                        child: _buildSelectedPointCard(
                            'Dropping',
                            _selectedDroppingPoint!,
                            AppTheme.AppColors.redCA0)),
                ],
              ),
            if (_selectedBoardingPoint != null ||
                _selectedDroppingPoint != null)
              const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _selectedBoardingPoint != null &&
                          _selectedDroppingPoint != null
                      ? [
                          AppTheme.AppColors.redCA0,
                          AppTheme.AppColors.redCA0.withOpacity(0.9),
                        ]
                      : [
                          Colors.grey[400]!,
                          Colors.grey[500]!,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: _selectedBoardingPoint != null &&
                        _selectedDroppingPoint != null
                    ? [
                        BoxShadow(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.4),
                          blurRadius: 16,
                          spreadRadius: 0,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _selectedBoardingPoint != null &&
                          _selectedDroppingPoint != null
                      ? _onContinuePressed
                      : null,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildSelectedPointCard(
          String title, BoardingPoint point, Color accentColor) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withOpacity(0.1),
              accentColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accentColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [accentColor, accentColor.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    title.contains('Boarding')
                        ? Icons.departure_board
                        : Icons.flag,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              point.name,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.titleLarge?.color ??
                    Colors.black87,
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _formatTime(point.time),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );

  void _onContinuePressed() {
    if (_selectedBoardingPoint == null || _selectedDroppingPoint == null) {
      HapticFeedback.heavyImpact();
      Get.snackbar(
        'Required',
        'Please select both boarding and dropping points',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.AppColors.redCA0,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.info_outline, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      return;
    }
    HapticFeedback.mediumImpact();

    double fare = 0.0;
    if (widget.fare != null && widget.fare!.isNotEmpty) {
      fare = double.tryParse(widget.fare!) ?? 0.0;
    }

    // Extract seat names from Seat objects or strings
    final List<String> selectedSeats = widget.selectedSeats != null
        ? widget.selectedSeats!
            .map((e) {
              // If it's already a string, use it directly
              if (e is String) {
                return e;
              }
              // If it's a Seat object, extract the seatName property
              if (e is Seat) {
                return e.seatName;
              }
              // If it's a Map (serialized), try to get seatName
              if (e is Map) {
                return e['seatName']?.toString() ??
                    e['SeatName']?.toString() ??
                    e.toString();
              }
              // Fallback to string conversion
              return e.toString();
            })
            .toList()
            .cast<String>()
        : <String>[];

    // Extract full seat objects if available
    final List<dynamic>? selectedSeatsObjects = widget.selectedSeats;

    Get.to(
      () => BusPassengerDetailsScreen(
        fromCity: widget.fromCity ?? 'Unknown',
        toCity: widget.toCity ?? 'Unknown',
        busName: widget.busName ?? 'Bus',
        travelDate: widget.journeyDate ?? 'Date not specified',
        departureTime: widget.departureTime ?? '--:--',
        arrivalTime: widget.arrivalTime ?? '--:--',
        fare: fare,
        selectedSeats: selectedSeats,
        selectedSeatsObjects: selectedSeatsObjects,
        boardingPoint: _selectedBoardingPoint?.name ?? 'Not selected',
        droppingPoint: _selectedDroppingPoint?.name ?? 'Not selected',
        traceId: widget.traceId ?? '',
        resultIndex: widget.resultIndex ?? 0,
        boardingPointId: _selectedBoardingPoint?.id ??
            _selectedBoardingPoint?.cityPointIndex ??
            '',
        droppingPointId: _selectedDroppingPoint?.id ??
            _selectedDroppingPoint?.cityPointIndex ??
            '',
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  String _formatTime(String time) {
    try {
      if (time.contains('T')) {
        final DateTime dateTime = DateTime.parse(time);
        return '${dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour)}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
      }
      return DateTimeHelper.convertTo12HourFormat(time);
    } catch (e) {
      return time;
    }
  }
}
