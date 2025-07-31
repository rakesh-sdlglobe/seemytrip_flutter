import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/trainfromSearchController.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class TrainAndBusFromScreen extends StatelessWidget {
  final TrainFromSearchController controller =
      Get.put(TrainFromSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and title
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xFFFEE8E8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Color(0xFFD32F2F),
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Select Departure Station',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Color(0xFFEEEEEE), width: 1.5),
                    ),
                    child: TextField(
                      controller: controller.fromController,
                      autofocus: true,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search for a city or station',
                        hintStyle: GoogleFonts.inter(
                          color: Color(0xFF999999),
                          fontSize: 15,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF999999),
                          size: 24,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (value) {
                        controller.fromController.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Section title
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text(
                'Popular Stations',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingState();
                  } else if (controller.hasError.value) {
                    return _buildErrorState();
                  } else if (controller.filteredStations.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    return _buildStationsList();
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationsList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 8),
      physics: BouncingScrollPhysics(),
      itemCount: controller.filteredStations.length,
      itemBuilder: (context, index) {
        final station = controller.filteredStations[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.selectStation(station);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.train_rounded,
                      color: Color(0xFFD32F2F),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      station,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF999999),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD32F2F)),
              strokeWidth: 2.5,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading stations...',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF5252),
            size: 48,
          ),
          SizedBox(height: 16),
          Text(
            'Failed to load stations',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              // Add retry logic here
            },
            child: Text(
              'Retry',
              style: GoogleFonts.inter(
                color: Color(0xFFD32F2F),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: Color(0xFFCCCCCC),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No stations found',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Try searching with a different name or check your spelling',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
