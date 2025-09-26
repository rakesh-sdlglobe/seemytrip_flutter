import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import '../controllers/traintoSearchController.dart';

class TrainToScreen extends StatelessWidget {
  final TrainToSearchController controller = Get.put(TrainToSearchController());

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.grey363
                    : AppColors.whiteF2F,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern Header
                _buildModernHeader(context),
                
                // Modern Search Section
                _buildModernSearchSection(context),
                
                // Modern Stations List
                Expanded(
                  child: _buildModernStationsList(context),
                ),
              ],
            ),
          ),
        ),
      );
  
  Widget _buildModernHeader(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
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
                          Icons.train_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Arrival Station',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Select your destination',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  
  Widget _buildModernSearchSection(BuildContext context) => Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redCA0.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.search_rounded,
                    color: AppColors.redCA0,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Search Stations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Modern Search Field
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.grey363.withOpacity(0.3)
                    : AppColors.greyEEE.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller.toController,
                autofocus: true,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Type city or station name...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).hintColor,
                    size: 24,
                  ),
                  suffixIcon: controller.toController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            controller.toController.clear();
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Theme.of(context).hintColor,
                            size: 20,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                onChanged: (value) {
                  controller.toController.text = value;
                },
              ),
            ),
          ],
        ),
      );
  
  Widget _buildModernStationsList(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.redCA0.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.location_city_rounded,
                      color: AppColors.redCA0,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Popular Stations',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
            
            // Stations List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildModernLoadingState();
                } else if (controller.hasError.value) {
                  return _buildModernErrorState();
                } else if (controller.filteredStations.isEmpty) {
                  return _buildModernEmptyState();
                } else {
                  return _buildModernStationsListView();
                }
              }),
            ),
          ],
        ),
      );
  
  Widget _buildModernStationsListView() => ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.filteredStations.length,
        itemBuilder: (context, index) {
          final station = controller.filteredStations[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {
                  controller.selectStation(station);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.redCA0.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.train_rounded,
                          color: AppColors.redCA0,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          station,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );


  Widget _buildModernLoadingState() {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.redCA0.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LoadingAnimationWidget.dotsTriangle(
                  color: AppColors.redCA0,
                  size: 40,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Loading stations...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernErrorState() {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.redCA0.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: AppColors.redCA0,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Unable to load station data. Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey717,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.redCA0,
                    AppColors.redCA0.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add retry logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernEmptyState() {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.grey717.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: AppColors.grey717,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No stations found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'We couldn\'t find any stations matching your search.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey717,
                ),
              ),
            ),
            const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.redCA0.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.redCA0.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.redCA0,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Try searching for major cities',
                      style: TextStyle(
                        color: AppColors.redCA0,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
