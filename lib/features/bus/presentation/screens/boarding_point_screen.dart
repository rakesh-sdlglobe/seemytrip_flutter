import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/bus_models.dart';
import '../controllers/bus_controller.dart';
import 'bus_passenger_details_screen.dart';


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

  LatLng _mapCenter =
      const LatLng(20.5937, 78.9629); // Default to center of India
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
        });
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
            onTap: () => setState(() {
              _selectedBoardingPoint = point;
                  if (_busController.boardingPointsResponse.value != null) {
                    _updateAllMarkers(
                        _busController.boardingPointsResponse.value!);
                  }
              _animateToSelectedPoint();
            }),
            child: Icon(
              Icons.location_pin,
              color: _selectedBoardingPoint?.id == point.id ? AppColors.accent : Colors.grey.shade600,
              size: _selectedBoardingPoint?.id == point.id ? 40 : 30,
              shadows: const <Shadow>[Shadow(color: Colors.black26, blurRadius: 4)],
            ),
          ),
        )).toList();

    _droppingMarkers = response.droppingPoints.map((BoardingPoint point) => Marker(
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
              color: _selectedDroppingPoint?.id == point.id ? AppColors.accent : Colors.grey.shade600,
              size: _selectedDroppingPoint?.id == point.id ? 40 : 30,
              shadows: const <Shadow>[Shadow(color: Colors.black26, blurRadius: 4)],
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
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: const Text('Boarding & Dropping'),
            backgroundColor: AppColors.primary,
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.1),
          ),
          SliverToBoxAdapter(child: _buildJourneySummary()),
          SliverToBoxAdapter(child: _buildMapView()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const <Widget>[
                  Tab(text: 'BOARDING'),
                  Tab(text: 'DROPPING'),
                ],
              ),
            ),
          ),
          Obx(() {
            if (_busController.isLoading.value && !_isMapReady) {
              return SliverFillRemaining(child: Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.black, size: 40)));
            }
            
            final BoardingPointResponse? response = _busController.boardingPointsResponse.value;
            if (response == null) {
              return const SliverFillRemaining(child: Center(child: Text('No points available')));
            }

            return SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
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

  Widget _buildJourneySummary() => Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.busName ?? 'Unknown Bus', style: AppTextStyles.heading1),
          const SizedBox(height: 4),
          Text('${widget.fromCity ?? 'Unknown'} to ${widget.toCity ?? 'Unknown'}', style: AppTextStyles.bodyMedium),
        ],
      ),
    );

  Widget _buildMapView() => SizedBox(
      height: 220,
      child: _isMapReady
          ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _mapCenter,
                initialZoom: 15.0,
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.seemytrip',
                ),
                MarkerLayer(markers: _tabController.index == 0 ? _boardingMarkers : _droppingMarkers),
              ],
            )
          : Container(
              height: 220,
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LoadingAnimationWidget.dotsTriangle(color: Colors.black, size: 40),
                    SizedBox(height: 10),
                    Text('Loading Map...'),
                  ],
                ),
              ),
            ),
    );

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
      itemBuilder: (BuildContext context, int index) {
        final BoardingPoint point = points[index];
        final bool isSelected = _selectedBoardingPoint?.id == point.id;
        return _buildPointItem(
          point: point,
          isSelected: isSelected,
          accentColor: AppColors.accent,
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
      itemBuilder: (BuildContext context, int index) {
        final BoardingPoint point = points[index];
        final bool isSelected = _selectedDroppingPoint?.id == point.id;
        return _buildPointItem(
          point: point,
          isSelected: isSelected,
          accentColor: AppColors.accent,
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
    final String time = point.time ?? '--:--';
    final String location = point.location ?? 'Location not specified';
    final String address = point.address ?? '';
    final String landmark = point.landmark ?? '';
    final String name = point.name ?? 'Unnamed Point';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shadowColor: isSelected ? accentColor.withOpacity(0.3) : Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? accentColor : AppColors.border,
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
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            time,
                            style: AppTextStyles.bodySmall.copyWith(
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
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (location.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                    if (address.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        address,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                    if (landmark.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 6),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.place_outlined,
                            size: 14,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Near $landmark',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textHint,
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
                    color: AppColors.border,
                    size: 24,
                  ),
                 )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: <BoxShadow>[
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
        children: <Widget>[
          Row(
            children: <Widget>[
              if (_selectedBoardingPoint != null)
                Expanded(
                    child: _buildSelectedPointCard('Boarding',
                        _selectedBoardingPoint!, AppColors.accent)),
              const SizedBox(width: 12),
              if (_selectedDroppingPoint != null)
                Expanded(
                    child: _buildSelectedPointCard(
                        'Dropping',
                        _selectedDroppingPoint!,
                        AppColors.accent)),
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
                textStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
                elevation: 2,
              ),
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );

  Widget _buildSelectedPointCard(String title, BoardingPoint point, Color accentColor) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                title.contains('Boarding') ? Icons.departure_board : Icons.flag,
                color: accentColor,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            point.name ?? 'Unnamed Point',
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            point.time,
            style: AppTextStyles.bodySmall,
          ),
        ],
      );

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

    double fare = 0.0;
    if (widget.fare != null && widget.fare!.isNotEmpty) {
      fare = double.tryParse(widget.fare!) ?? 0.0;
    }

    final List<String> selectedSeats = widget.selectedSeats != null 
        ? List<String>.from(widget.selectedSeats!.map((e) => e.toString())) 
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(
      color: AppColors.surface,
      child: _tabBar,
    );

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
