import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../../core/widgets/dynamic_language_selector.dart';
import '../../../../../core/widgets/global_language_wrapper.dart';
import '../../../../../shared/constants/images.dart';
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
  
  Widget _buildModernHeader(BuildContext context) => Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.redCA0,
            AppColors.redCA0.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.redCA0.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Back Button
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Header Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.flight_takeoff_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'flightSearch'.tr,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'findBestFlights'.tr,
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Language Selector
              QuickLanguageSwitcher(),
            ],
          ),
        ),
      ),
    );
  
  Widget _buildModernTabBar(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: GetBuilder<FlightSearchController>(
        builder: (FlightSearchController controller) {
          if (!controller.isControllerInitialized) {
            return Container(
              height: 56,
              child: Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: AppColors.redCA0,
                  size: 20,
                ),
              ),
            );
          }
          return Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: controller.tabController,
              isScrollable: false,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [AppColors.redCA0, AppColors.redCA0.withOpacity(0.8)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.redCA0.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.white,
              unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
              labelStyle: const TextStyle(
                fontFamily: 'PoppinsSemiBold',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'PoppinsMedium',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: controller.myTabs.map((tab) {
                return Container(
                  height: 56,
                  child: Center(child: tab),
                );
              }).toList(),
              onTap: (int index) {
                controller.tabController.animateTo(index);
              },
            ),
          );
        },
      ),
    );
  
  Widget _buildModernOfferBanner(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.redF9E,
            AppColors.redF9E.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.redCA0.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Offer Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.redCA0.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              offerIcon,
              width: 20,
              height: 20,
              color: AppColors.redCA0,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Offer Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'specialOffer'.tr,
                  style: TextStyle(
                    color: AppColors.redCA0,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'getFlatOff'.tr,
                  style: TextStyle(
                    color: AppColors.redCA0.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Arrow Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.redCA0.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.redCA0,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
