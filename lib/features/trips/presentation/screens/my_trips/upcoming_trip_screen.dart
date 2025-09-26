import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';

class UpComingTripScreen extends StatelessWidget {
  UpComingTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: Lists.myTripList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildTripCard(context, index, isDark),
        ),
      ),
    );
  }

  Widget _buildTripCard(BuildContext context, int index, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark 
            ? Border.all(color: AppColors.borderDark.withValues(alpha: 0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? AppColors.shadowDark.withValues(alpha: 0.3)
                : AppColors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image section
          Container(
            height: 140,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage(Lists.myTripList[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.redCA0,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CommonTextWidget.PoppinsMedium(
                      text: 'Upcoming',
                      color: AppColors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content section
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextWidget.PoppinsBold(
                  text: 'Top 5 Indian Destinations for a Fun Family Trip',
                  color: isDark ? AppColors.textPrimaryDark : AppColors.black2E2,
                  fontSize: 16,
                ),
                SizedBox(height: 8),
                CommonTextWidget.PoppinsRegular(
                  text: 'Explore Himachal Pradesh & 4 more places',
                  color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                  fontSize: 14,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                    ),
                    SizedBox(width: 6),
                    CommonTextWidget.PoppinsMedium(
                      text: 'Dec 15, 2024 - Dec 20, 2024',
                      color: isDark ? AppColors.textSecondaryDark : AppColors.grey656,
                      fontSize: 12,
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.redCA0.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CommonTextWidget.PoppinsMedium(
                        text: 'View Details',
                        color: AppColors.redCA0,
                        fontSize: 12,
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
  }
}
