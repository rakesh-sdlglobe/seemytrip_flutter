import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seemytrip/core/theme/app_colors.dart' as AppTheme;
import 'package:shimmer/shimmer.dart';

import '../../../../shared/models/bus_models.dart';
import '../controllers/bus_controller.dart';
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

class _BoardingPointScreenState extends State<BoardingPointScreen> with TickerProviderStateMixin {
  final BusController _busController = Get.find<BusController>();
  BoardingPoint? _selectedBoardingPoint;
  BoardingPoint? _selectedDroppingPoint;

  final MapController _mapController = MapController();
  List<Marker> _boardingMarkers = <Marker>[];
  List<Marker> _droppingMarkers = <Marker>[];
  
  late final TabController _tabController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  LatLng _mapCenter =
      const LatLng(20.5937, 78.9629); // Default to center of India
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
            _animateToSelectedPoint();
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
    _mapController.dispose();
    super.dispose();
  }

  String _convertTo12HourFormat(String time24) {
    if (time24.isEmpty || time24 == '--:--' || !time24.contains(':')) {
      return time24;
    }
    
    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;
      
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;
      
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return time24;
      }
      
      String period = hour >= 12 ? 'PM' : 'AM';
      int hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      String minuteStr = minute.toString().padLeft(2, '0');
      
      return '$hour12:$minuteStr $period';
    } catch (e) {
      return time24;
    }
  }

  Future<void> _loadPoints() async {
    if (widget.traceId == null || widget.resultIndex == null) {
        debugPrint('Error: traceId or resultIndex is null.');
        if (mounted) Get.snackbar('Error', 'Could not load boarding points. Missing required information.', snackPosition: SnackPosition.BOTTOM);
        return;
    }

    try {
      final BoardingPointResponse? response = await _busController.getBoardingPoints(
        traceId: widget.traceId!,
        resultIndex: widget.resultIndex!,
      );
      
      if (mounted && response != null) {
        setState(() {
          if (response.boardingPoints.isNotEmpty) {
             _selectedBoardingPoint = response.boardingPoints.firstWhere(
              (BoardingPoint p) => p.isDefault, 
              orElse: () => response.boardingPoints.first,
            );
            _mapCenter = LatLng(_selectedBoardingPoint!.latitude, _selectedBoardingPoint!.longitude);
            _isMapReady = true;
          }
          if (response.droppingPoints.isNotEmpty) {
            _selectedDroppingPoint = response.droppingPoints.firstWhere(
              (BoardingPoint p) => p.isDefault, 
              orElse: () => response.droppingPoints.first,
            );
          }
          
          _updateAllMarkers(response);
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      debugPrint('Error loading points: $e');
      if (mounted) Get.snackbar('Error', 'Failed to load points.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _updateAllMarkers(BoardingPointResponse response) {
    _boardingMarkers = response.boardingPoints.map((BoardingPoint point) => Marker(
          width: 80,
          height: 80,
          point: LatLng(point.latitude, point.longitude),
            child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _selectedBoardingPoint = point;
                    if (_busController.boardingPointsResponse.value != null) {
                      _updateAllMarkers(
                          _busController.boardingPointsResponse.value!);
                    }
                _animateToSelectedPoint();
              });
            },
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _selectedBoardingPoint?.id == point.id ? 1.15 : 1.0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedBoardingPoint?.id == point.id 
                      ? AppTheme.AppColors.redCA0
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _selectedBoardingPoint?.id == point.id
                          ? AppTheme.AppColors.redCA0.withOpacity(0.5)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: _selectedBoardingPoint?.id == point.id ? 12 : 6,
                      spreadRadius: _selectedBoardingPoint?.id == point.id ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: _selectedBoardingPoint?.id == point.id 
                      ? Colors.white
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                  size: _selectedBoardingPoint?.id == point.id ? 32 : 24,
                ),
              ),
            ),
          ),
        )).toList();

    _droppingMarkers = response.droppingPoints.map((BoardingPoint point) => Marker(
          width: 80,
          height: 80,
          point: LatLng(point.latitude, point.longitude),
            child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              setState(() {
                _selectedDroppingPoint = point;
                if (_busController.boardingPointsResponse.value != null) {
                  _updateAllMarkers(_busController.boardingPointsResponse.value!);
                }
                _animateToSelectedPoint();
              });
            },
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: _selectedDroppingPoint?.id == point.id ? 1.15 : 1.0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedDroppingPoint?.id == point.id 
                      ? AppTheme.AppColors.redCA0
                      : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _selectedDroppingPoint?.id == point.id
                          ? AppTheme.AppColors.redCA0.withOpacity(0.5)
                          : Colors.black.withOpacity(0.2),
                      blurRadius: _selectedDroppingPoint?.id == point.id ? 12 : 6,
                      spreadRadius: _selectedDroppingPoint?.id == point.id ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: _selectedDroppingPoint?.id == point.id 
                      ? Colors.white
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600),
                  size: _selectedDroppingPoint?.id == point.id ? 32 : 24,
                ),
              ),
            ),
          ),
        )).toList();
  }

  void _animateToSelectedPoint() {
    LatLng? target;
    if (_tabController.index == 0 && _selectedBoardingPoint != null) {
      target = LatLng(_selectedBoardingPoint!.latitude, _selectedBoardingPoint!.longitude);
    } else if (_tabController.index == 1 && _selectedDroppingPoint != null) {
      target = LatLng(_selectedDroppingPoint!.latitude, _selectedDroppingPoint!.longitude);
    }
    
    if (target != null) {
      _mapController.move(target, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Journey Summary Card
            _buildJourneySummary(),
            // Map View
            _buildMapView(),
            // Tab Bar
            _buildTabBar(),
            // Selected Point Card (if selected)
            Builder(
              builder: (context) {
                final bool isBoardingTab = _tabController.index == 0;
                final BoardingPoint? selectedPoint = isBoardingTab ? _selectedBoardingPoint : _selectedDroppingPoint;
                if (selectedPoint != null) {
                  return _buildSelectedPointHighlightCard(selectedPoint, isBoardingTab);
                }
                return const SizedBox.shrink();
              },
            ),
            // Points List
            Expanded(
              child: _buildPointsContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildContinueButton(),
    );
  }

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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
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
      final BoardingPointResponse? response = _busController.boardingPointsResponse.value;
      
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
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
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
          _buildBoardingPointsList(response.boardingPoints),
          _buildDroppingPointsList(response.droppingPoints),
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
              colors: [AppTheme.AppColors.redCA0, AppTheme.AppColors.redCA0.withOpacity(0.9)],
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
          labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          tabs: const <Widget>[
            Tab(text: 'BOARDING'),
            Tab(text: 'DROPPING'),
          ],
        ),
      );

  Widget _buildSelectedPointHighlightCard(BoardingPoint point, bool isBoarding) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.AppColors.redCA0,
              AppTheme.AppColors.redCA0.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.AppColors.redCA0.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _convertTo12HourFormat(point.time),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    point.name,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.check_rounded,
                color: AppTheme.AppColors.redCA0,
                size: 20,
              ),
            ),
          ],
        ),
      );

  Widget _buildJourneySummary() => Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.AppColors.redCA0, AppTheme.AppColors.redCA0.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.busName ?? 'Unknown Bus',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: AppTheme.AppColors.redCA0),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${widget.fromCity ?? 'Unknown'} → ${widget.toCity ?? 'Unknown'}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildMapView() => Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _isMapReady
          ? Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _mapCenter,
                    initialZoom: 15.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.seemytrip',
                    ),
                    MarkerLayer(markers: _tabController.index == 0 ? _boardingMarkers : _droppingMarkers),
                  ],
                ),
                // Center pin indicator
                Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.AppColors.redCA0,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            )
          : Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue[50]!,
                    Colors.blue[100]!,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: AppTheme.AppColors.redCA0, 
                      size: 40
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Loading Map...',
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
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
          height: 100,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildBoardingPointsList(List<BoardingPoint> points) {
    if (points.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No boarding points available',
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
    
    // Filter out selected point from list
    final List<BoardingPoint> filteredPoints = points.where((p) => p.id != _selectedBoardingPoint?.id).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredPoints.length,
      itemBuilder: (BuildContext context, int index) {
        final BoardingPoint point = filteredPoints[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 200 + (index * 30)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 15 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: RepaintBoundary(
                  child: _buildPointItem(
                    point: point,
                    isSelected: false,
                    accentColor: AppTheme.AppColors.redCA0,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _selectedBoardingPoint = point;
                        if (_busController.boardingPointsResponse.value != null) {
                            _updateAllMarkers(_busController.boardingPointsResponse.value!);
                        }
                        _animateToSelectedPoint();
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildDroppingPointsList(List<BoardingPoint> points) {
    if (points.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No dropping points available',
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
    
    // Filter out selected point from list
    final List<BoardingPoint> filteredPoints = points.where((p) => p.id != _selectedDroppingPoint?.id).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredPoints.length,
      itemBuilder: (BuildContext context, int index) {
        final BoardingPoint point = filteredPoints[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 200 + (index * 30)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 15 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: RepaintBoundary(
                  child: _buildPointItem(
                    point: point,
                    isSelected: false,
                    accentColor: AppTheme.AppColors.redCA0,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _selectedDroppingPoint = point;
                        if (_busController.boardingPointsResponse.value != null) {
                            _updateAllMarkers(_busController.boardingPointsResponse.value!);
                        }
                        _animateToSelectedPoint();
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPointItem({
    required BoardingPoint point,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final String time = _convertTo12HourFormat(point.time);
    final String location = point.location;
    final String address = point.address;
    final String landmark = point.landmark;
    final String name = point.name;
    
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween(begin: 1.0, end: isSelected ? 1.02 : 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                splashColor: accentColor.withOpacity(0.1),
                highlightColor: accentColor.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [accentColor, accentColor.withOpacity(0.8)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected ? null : accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? accentColor.withOpacity(0.3) : accentColor.withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: accentColor.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: isSelected ? Colors.white : accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [accentColor, accentColor.withOpacity(0.8)],
                                          )
                                        : null,
                                    color: isSelected ? null : accentColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: accentColor.withOpacity(isSelected ? 0.3 : 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    time,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isSelected ? Colors.white : accentColor,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87,
                                letterSpacing: 0.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (location.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.map_outlined, size: 14, color: Theme.of(context).textTheme.bodySmall?.color,),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (address.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 4),
                              Text(
                                address,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (landmark.isNotEmpty) ...<Widget>[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[800]!.withOpacity(0.5)
                                      : Colors.grey[100]!.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.place_outlined,
                                      size: 14,
                                      color: accentColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        'Near $landmark',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [accentColor, accentColor.withOpacity(0.9)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).dividerColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).dividerColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.circle_outlined,
                            color: Theme.of(context).dividerColor,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
          if (_selectedBoardingPoint != null || _selectedDroppingPoint != null)
            Row(
              children: <Widget>[
                if (_selectedBoardingPoint != null)
                  Expanded(
                      child: _buildSelectedPointCard('Boarding',
                          _selectedBoardingPoint!, AppTheme.AppColors.redCA0)),
                if (_selectedBoardingPoint != null && _selectedDroppingPoint != null)
                  const SizedBox(width: 12),
                if (_selectedDroppingPoint != null)
                  Expanded(
                      child: _buildSelectedPointCard(
                          'Dropping',
                          _selectedDroppingPoint!,
                          AppTheme.AppColors.redCA0)),
              ],
            ),
          if (_selectedBoardingPoint != null || _selectedDroppingPoint != null)
            const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _selectedBoardingPoint != null && _selectedDroppingPoint != null
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
              boxShadow: _selectedBoardingPoint != null && _selectedDroppingPoint != null
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
                onTap: _selectedBoardingPoint != null && _selectedDroppingPoint != null
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

  Widget _buildSelectedPointCard(String title, BoardingPoint point, Color accentColor) => Container(
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
                    title.contains('Boarding') ? Icons.departure_board : Icons.flag,
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
                color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87,
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
                _convertTo12HourFormat(point.time),
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
        ? widget.selectedSeats!.map((e) {
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
          }).toList().cast<String>()
        : <String>[];

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
        boardingPoint: _selectedBoardingPoint?.name ?? 'Not selected',
        droppingPoint: _selectedDroppingPoint?.name ?? 'Not selected',
        traceId: widget.traceId ?? '',
        resultIndex: widget.resultIndex ?? 0,
        boardingPointId: _selectedBoardingPoint?.id ?? _selectedBoardingPoint?.cityPointIndex ?? '',
        droppingPointId: _selectedDroppingPoint?.id ?? _selectedDroppingPoint?.cityPointIndex ?? '',
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}

