import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../features/common/presentation/screens/coming_soon_screen.dart';

import '../../../../features/home/presentation/controllers/navigation_controller.dart';
import '../../../../features/home/presentation/screens/DrawerScreen/drawer_screen.dart';
import '../../../../features/home/presentation/screens/home_screen.dart';
import '../../../../features/home/presentation/screens/where_to_go/where_2_go_screen.dart';
import '../../../../features/profile/presentation/screens/account/my_account_screen.dart';
import '../../../../features/trips/presentation/screens/my_trips/my_trip_screen.dart';
import '../../../../shared/constants/images.dart';
import '../../../theme/app_colors.dart';

class NavigationScreen extends StatelessWidget {
  NavigationScreen({this.token});
  final String? token;

  final NavigationController navigationController =
      Get.put(NavigationController());

  final pages = [
    HomeScreen(),
    MyTripScreen(),
    Where2GoScreen(),
    MyAccountScreen(),
  ];

  Widget buildMyNavBar(BuildContext context) => Container(
      height: 85,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(25),
        border: Theme.of(context).brightness == Brightness.dark ? Border.all(
          color: AppColors.borderDark.withValues(alpha: 0.3),
          width: 1,
        ) : null,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.shadowDark.withValues(alpha: 0.3)
                : AppColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.redCA0.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: homeSelectedIcon,
              unselectedIcon: homeUnSelectedIcon,
              label: "home".tr,
              index: 0,
              isSelected: navigationController.pageIndex.value == 0,
              onTap: () => navigationController.pageIndex.value = 0,
            ),
            _buildNavItem(
              context: context,
              icon: suitcaseIcon,
              unselectedIcon: suitcaseIcon,
              label: "myTrips".tr,
              index: 1,
              isSelected: false,
              onTap: () => Get.to(() => MyTripScreen()),
            ),
            _buildNavItem(
              context: context,
              icon: selectedRightArrow,
              unselectedIcon: unSelectedRightArrow,
              label: "whereToGo".tr,
              index: 2,
              isSelected: navigationController.pageIndex.value == 2,
              onTap: () => Get.to(() => const ComingSoonScreen()),
            ),
            _buildNavItem(
              context: context,
              icon: userIcon,
              unselectedIcon: userIcon,
              label: "myAccount".tr,
              index: 3,
              isSelected: false,
              onTap: () => Get.to(() => MyAccountScreen()),
            ),
          ],
        ),
      ),
    );

  Widget _buildNavItem({
    required BuildContext context,
    required String icon,
    required String unselectedIcon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final isCurrentlySelected = navigationController.pageIndex.value == index;
      return Expanded(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isCurrentlySelected 
                  ? AppColors.redCA0.withValues(alpha: 0.1) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isCurrentlySelected 
                        ? AppColors.redCA0.withValues(alpha: 0.15) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    isCurrentlySelected ? icon : unselectedIcon,
                    height: 20,
                    width: 20,
                    colorFilter: isCurrentlySelected 
                        ? null 
                        : ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.greyAAA, 
                            BlendMode.srcIn
                          ),
                  ),
                ),
                SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isCurrentlySelected 
                        ? AppColors.redCA0 
                        : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.greyAAA),
                    fontSize: 10,
                    fontWeight: isCurrentlySelected 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return Scaffold(
        key: key,
        backgroundColor: AppColors.white,
        drawer: Drawer(
          backgroundColor: AppColors.white,
          child: DrawerScreen(),
        ),
        body: Stack(
          children: [
            Obx(
              () => Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  pages[navigationController.pageIndex.value],
                  buildMyNavBar(context),
                ],
              ),
            ),
            Obx(() => navigationController.pageIndex.value == 0
                  ? Positioned(
                      top: 65,
                      left: 24,
                      child: InkWell(
                        onTap: () {
                          key.currentState!.openDrawer();
                        },
                        child: Image.asset(menuIcon, height: 42, width: 42),
                      ),
                    )
                  : SizedBox()),
          ],
        ));
  }
}
