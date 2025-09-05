import 'dart:ui'; // Import needed for the blur effect (ImageFilter)
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming these are your actual imports
import '../../controllers/flight_search_controller.dart';
import '../../controllers/flight_controller.dart'; // <--- make sure this exists
import '../../theme/flight_theme.dart';
import 'multicity_screen.dart';
import 'one_way_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({Key? key}) : super(key: key);

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> with TickerProviderStateMixin {
  late final FlightSearchTabController _tabController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Register the missing FlightController so Get.find works
    if (!Get.isRegistered<FlightController>()) {
      Get.put(FlightController());
    }

    // Initialize the tab controller
    _tabController = Get.put(FlightSearchTabController());

    // --- Initialize Animations ---
    _animationController = AnimationController(
      vsync: this, // Use this (the State) as the TickerProvider
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    // Stop any ongoing animations first
    _animationController..stop()
    ..dispose();
    
    // Let GetX handle the tab controller disposal
    if (Get.isRegistered<FlightController>()) {
      try {
        Get.delete<FlightController>();
      } catch (e) {
        // Ignore if already disposed
      }
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
        data: FlightTheme.themeData,
        child: Scaffold(
          backgroundColor: FlightTheme.backgroundColor,
          body: Stack(
            children: [
              _buildHeaderBackground(),
              SafeArea(
                child: Column(
                  children: [
                    _buildCustomAppBar(),
                    const SizedBox(height: 20),
                    _buildTabBar(),
                    Expanded(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              _buildOfferBanner(),
                              _buildTabContent(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCustomAppBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            const Expanded(
              child: Text(
                'Search Flights ✈️',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      );

  Widget _buildTabBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tabController.controller,
                labelColor: FlightTheme.primaryColor,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                dividerHeight: 0,
                tabs: const <Widget>[
                  Tab(text: 'One Way'),
                  Tab(text: 'Multi-City'),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildOfferBanner() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade300, Colors.orange.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.local_offer,
                    color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Flat 13% OFF on your first booking!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTabContent() => Expanded(
        child: TabBarView(
          controller: _tabController.controller,
          children: [
            OneWayScreen(),
            MultiCityScreen(),
          ],
        ),
      );

  Widget _buildHeaderBackground() => ClipPath(
        clipper: CurvedClipper(),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [FlightTheme.primaryColor, FlightTheme.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      );
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
