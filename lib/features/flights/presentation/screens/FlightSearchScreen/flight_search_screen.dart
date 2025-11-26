import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/dynamic_language_selector.dart';
import '../../../../../core/widgets/global_language_wrapper.dart';
import '../../controllers/flight_search_controller.dart';
import 'multicity_screen.dart';
import 'one_way_screen.dart';
import 'round_trip_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({Key? key}) : super(key: key);

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> with TickerProviderStateMixin {
  late final FlightSearchController flightSearchController;
  
  @override
  void initState() {
    super.initState();
    flightSearchController = Get.put(FlightSearchController());
    // Initialize tabController immediately
    flightSearchController.init(this);
  }
  
  @override
  void dispose() {
    // The controller will be disposed by GetX
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => GlobalLanguageWrapper(
    child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Modern Header
          _buildModernHeader(context),
          
          // Modern Tab Section
          Expanded(
            child: Column(
              children: [
                // Modern Tab Bar
                _buildModernTabBar(context),
                
                // Modern Offer Banner
                // _buildModernOfferBanner(context),
                
                // Tab Content
                Expanded(
                  child: GetBuilder<FlightSearchController>(
                    builder: (FlightSearchController controller) {
                      if (!controller.isControllerInitialized) {
                        return Center(
                          child: LoadingAnimationWidget.dotsTriangle(
                            color: AppColors.redCA0,
                            size: 24,
                          ),
                        );
                      }
                      return TabBarView(
                        controller: controller.tabController,
                        children: <Widget>[
                          OneWayScreen(),
                          RoundTripScreen(),
                          MulticityScreen(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  
  Widget _buildModernHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar with Back Button and Actions
            Row(
              children: [
                // Back Button with subtle background
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onPrimary),
                    onPressed: () => Get.back(),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Language Selector with subtle background
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QuickLanguageSwitcher(),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Header Content
            Row(
              children: [
                // Icon with subtle background
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.flight_takeoff_rounded,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Title and Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with subtle text shadow
                      Text(
                        'flightSearch'.tr,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Subtitle with subtle transparency
                      Text(
                        'findBestFlights'.tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModernTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GetBuilder<FlightSearchController>(
      builder: (controller) {
        if (!controller.isControllerInitialized) {
          return const SizedBox.shrink();
        }
        
        return TabBar(
          controller: controller.tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: theme.unselectedWidgetColor,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 2,
          tabs: [
            Tab(text: 'oneWay'.tr),
            Tab(text: 'roundTrip'.tr),
            Tab(text: 'multiCity'.tr),
          ],
          labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        );
      },
    );
  }
}