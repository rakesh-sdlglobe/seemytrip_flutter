import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:seemytrip/Screens/HomeScreen/BusScreen/bus_passenger_details_screen.dart';

import '../../../Controller/bus_controller.dart';
import '../../../Models/bus_models.dart';
import '../../../utils/colors.dart';
import '../../../utils/styles.dart' as app_styles;

// Re-export the theme colors and styles for convenience
class BoardingPointColors {
  static const Color primary = AppColors.primary;
  static const Color accent = AppColors.secondary;
  static const Color accentDropping = AppColors.primaryDark;
  static const Color background = AppColors.background;
  static const Color card = AppColors.surface;
  static const Color textDark = AppColors.onSurface;
  static const Color textLight = AppColors.textSecondary;
  static const Color border = AppColors.divider;
}

class BoardingPointStyles {
  static TextStyle get heading1 => app_styles.AppStyles.headlineSmall.copyWith(
        fontWeight: FontWeight.bold,
        color: BoardingPointColors.textDark,
      );

  static TextStyle get heading2 => app_styles.AppStyles.titleLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: BoardingPointColors.textDark,
      );

  static TextStyle get body => app_styles.AppStyles.bodyMedium.copyWith(
        color: BoardingPointColors.textLight,
      );

  static TextStyle get bodyBold => app_styles.AppStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: BoardingPointColors.textDark,
      );
}


class BoardingPointScreen extends StatefulWidget {
  // --- FIX: Made properties nullable to prevent crash on null arguments ---
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
  List<Marker> _boardingMarkers = [];
  List<Marker> _droppingMarkers = [];
  
  late final TabController _tabController;

  // --- FIX: State variable to hold the map's center coordinate ---
  LatLng _mapCenter = const LatLng(20.5937, 78.9629); // Default to India
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
        if (_tabController.indexIsChanging) {
          setState(() {
            _animateToSelectedPoint();
          });
        }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPoints();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadPoints() async {
    if (widget.traceId == null || widget.resultIndex == null) {
        debugPrint('Error: traceId or resultIndex is null.');
        if (mounted) Get.snackbar('Error', 'Could not load boarding points. Missing required information.', snackPosition: SnackPosition.BOTTOM);
        return;
    }

    try {
      final response = await _busController.getBoardingPoints(
        traceId: widget.traceId!,
        resultIndex: widget.resultIndex!,
      );
      
      if (mounted && response != null) {
        setState(() {
          if (response.boardingPoints.isNotEmpty) {
             _selectedBoardingPoint = response.boardingPoints.firstWhere(
              (p) => p.isDefault, 
              orElse: () => response.boardingPoints.first,
            );
            // --- FIX: Set the initial map center to the first boarding point ---
            _mapCenter = LatLng(_selectedBoardingPoint!.latitude, _selectedBoardingPoint!.longitude);
            _isMapReady = true;
          }
          if (response.droppingPoints.isNotEmpty) {
            _selectedDroppingPoint = response.droppingPoints.firstWhere(
              (p) => p.isDefault, 
              orElse: () => response.droppingPoints.first,
            );
          }
         
          _updateAllMarkers(response);
          // No need to animate on initial load, map is already centered
        });
      }
    } catch (e) {
      debugPrint('Error loading points: $e');
      if (mounted) Get.snackbar('Error', 'Failed to load points.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _updateAllMarkers(BoardingPointResponse response) {
    _boardingMarkers = response.boardingPoints.map((point) => Marker(
          width: 80,
          height: 80,
          point: LatLng(point.latitude, point.longitude),
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedBoardingPoint = point;
               if (_busController.boardingPointsResponse.value != null) {
                 _updateAllMarkers(_busController.boardingPointsResponse.value!);
               }
              _animateToSelectedPoint();
            }),
            child: Icon(
              Icons.location_pin,
              color: _selectedBoardingPoint?.id == point.id ? BoardingPointColors.accent : Colors.grey.shade600,
              size: _selectedBoardingPoint?.id == point.id ? 40 : 30,
              shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
          ),
        )).toList();

    _droppingMarkers = response.droppingPoints.map((point) => Marker(
          width: 80,
          height: 80,
          point: LatLng(point.latitude, point.longitude),
          child: GestureDetector(
            onTap: () => setState(() {
              _selectedDroppingPoint = point;
              if (_busController.boardingPointsResponse.value != null) {
                _updateAllMarkers(_busController.boardingPointsResponse.value!);
              }
              _animateToSelectedPoint();
            }),
            child: Icon(
              Icons.location_pin,
              color: _selectedDroppingPoint?.id == point.id ? BoardingPointColors.accentDropping : Colors.grey.shade600,
              size: _selectedDroppingPoint?.id == point.id ? 40 : 30,
              shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
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
      // Animate the map to the new target.
      _mapController.move(target, 15.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Boarding & Dropping'),
            backgroundColor: AppColors.surface,
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
          SliverToBoxAdapter(child: _buildJourneySummary()),
          SliverToBoxAdapter(child: _buildMapView()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: BoardingPointColors.textLight,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'BOARDING'),
                  Tab(text: 'DROPPING'),
                ],
              ),
            ),
          ),
          Obx(() {
            if (_busController.isLoading.value && !_isMapReady) {
              return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
            }
            
            final response = _busController.boardingPointsResponse.value;
            if (response == null) {
              return const SliverFillRemaining(child: Center(child: Text('No points available')));
            }

            return SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBoardingPointsList(response.boardingPoints),
                  _buildDroppingPointsList(response.droppingPoints),
                ],
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: _buildContinueButton(),
    );
  }

  Widget _buildJourneySummary() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.busName ?? 'Unknown Bus', style: BoardingPointStyles.heading1),
          const SizedBox(height: 4),
          Text('${widget.fromCity ?? 'Unknown'} to ${widget.toCity ?? 'Unknown'}', style: BoardingPointStyles.body),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return SizedBox(
      height: 220,
      child: _isMapReady
          ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                // --- FIX: Use state variable for center and a better zoom level ---
                initialCenter: _mapCenter,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app', // Recommended for tile server policy
                ),
                MarkerLayer(markers: _tabController.index == 0 ? _boardingMarkers : _droppingMarkers),
              ],
            )
          : Container(
              height: 220,
              color: Colors.grey[200],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading Map...'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBoardingPointsList(List<BoardingPoint> points) {
    if (points.isEmpty) {
      return const Center(
        child: Text(
          'No boarding points available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: points.length,
      itemBuilder: (context, index) {
        final point = points[index];
        final isSelected = _selectedBoardingPoint?.id == point.id;
        return _buildPointItem(
          point: point,
          isSelected: isSelected,
          accentColor: BoardingPointColors.accent,
          onTap: () => setState(() {
            _selectedBoardingPoint = point;
            if (_busController.boardingPointsResponse.value != null) {
                _updateAllMarkers(_busController.boardingPointsResponse.value!);
            }
            _animateToSelectedPoint();
          }),
        );
      },
    );
  }
  
  Widget _buildDroppingPointsList(List<BoardingPoint> points) {
    if (points.isEmpty) {
      return const Center(
        child: Text(
          'No dropping points available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: points.length,
      itemBuilder: (context, index) {
        final point = points[index];
        final isSelected = _selectedDroppingPoint?.id == point.id;
        return _buildPointItem(
          point: point,
          isSelected: isSelected,
          accentColor: BoardingPointColors.accentDropping,
          onTap: () => setState(() {
            _selectedDroppingPoint = point;
            if (_busController.boardingPointsResponse.value != null) {
                _updateAllMarkers(_busController.boardingPointsResponse.value!);
            }
            _animateToSelectedPoint();
          }),
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
    final time = point.time ?? '--:--';
    final location = point.location ?? 'Location not specified';
    final address = point.address ?? '';
    final landmark = point.landmark ?? '';
    final name = point.name ?? 'Unnamed Point';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shadowColor: isSelected ? accentColor.withOpacity(0.3) : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? accentColor : BoardingPointColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            time,
                            style: app_styles.AppStyles.bodySmall.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: app_styles.AppStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: BoardingPointColors.textDark,
                      ),
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: app_styles.AppStyles.bodyMedium.copyWith(
                          color: BoardingPointColors.textLight,
                        ),
                      ),
                    ],
                    if (address.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        address,
                        style: app_styles.AppStyles.bodySmall.copyWith(
                          color: BoardingPointColors.textLight,
                        ),
                      ),
                    ],
                    if (landmark.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.place_outlined,
                            size: 14,
                            color: BoardingPointColors.textLight,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Near $landmark',
                              style: app_styles.AppStyles.bodySmall.copyWith(
                                color: BoardingPointColors.textLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: accentColor,
                    size: 24,
                  ),
                )
              else
                 Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.radio_button_unchecked,
                    color: BoardingPointColors.border,
                    size: 24,
                  ),
                 )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: BoardingPointColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
               if (_selectedBoardingPoint != null)
                Expanded(child: _buildSelectedPointCard('Boarding', _selectedBoardingPoint!, BoardingPointColors.accent)),
               const SizedBox(width: 12),
               if (_selectedDroppingPoint != null)
                Expanded(child: _buildSelectedPointCard('Dropping', _selectedDroppingPoint!, BoardingPointColors.accentDropping)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _selectedBoardingPoint != null && _selectedDroppingPoint != null
                  ? _onContinuePressed
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: BoardingPointStyles.bodyBold.copyWith(fontSize: 16),
                elevation: 2,
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPointCard(String title, BoardingPoint point, Color accentColor) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                title.contains('Boarding') ? Icons.departure_board : Icons.flag,
                color: accentColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: BoardingPointStyles.bodyBold.copyWith(color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            point.name ?? 'Unnamed Point',
            style: BoardingPointStyles.bodyBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            point.time ?? '--:--',
            style: BoardingPointStyles.body.copyWith(fontSize: 12),
          ),
        ],
      );
  }

  void _onContinuePressed() {
    if (_selectedBoardingPoint == null || _selectedDroppingPoint == null) {
      Get.snackbar(
        'Error', 
        'Please select both boarding and dropping points',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Convert fare to double and handle null case
    double fare = 0.0;
    if (widget.fare != null && widget.fare!.isNotEmpty) {
      fare = double.tryParse(widget.fare!) ?? 0.0;
    }

    // Ensure selectedSeats is not null and properly typed
    final List<String> selectedSeats = widget.selectedSeats != null 
        ? List<String>.from(widget.selectedSeats!.map((e) => e.toString())) 
        : [];

    // Navigate to BusPassengerDetailsScreen with all required data
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
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
