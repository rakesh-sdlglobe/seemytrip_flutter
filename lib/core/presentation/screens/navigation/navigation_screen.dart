import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../features/home/presentation/controllers/navigation_controller.dart';
import '../../../../features/home/presentation/screens/DrawerScreen/drawer_screen.dart';
import '../../../../features/home/presentation/screens/home_screen.dart';
import '../../../../features/home/presentation/screens/where_to_go/where_2_go_screen.dart';
import '../../../../features/profile/presentation/screens/account/my_account_screen.dart';
import '../../../../features/trips/presentation/screens/my_trips/my_trip_screen.dart';
import '../../../../shared/constants/images.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/common_text_widget.dart';

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

  buildMyNavBar(BuildContext context) => Container(
      height: 85,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyB9B.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(
              () => Column(
                children: [
                  InkWell(
                    enableFeedback: false,
                    onTap: () {
                      navigationController.pageIndex.value = 0;
                    },
                    child: SvgPicture.asset(
                      navigationController.pageIndex.value == 0
                          ? homeSelectedIcon
                          : homeUnSelectedIcon,
                    ),
                  ),
                  SizedBox(height: 6),
                  CommonTextWidget.PoppinsMedium(
                    text: "Home",
                    color: navigationController.pageIndex.value == 0
                        ? AppColors.redCA0
                        : AppColors.greyAAA,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  enableFeedback: false,
                  onTap: () {
                    Get.to(() => MyTripScreen());
                  },
                  child: SvgPicture.asset(suitcaseIcon),
                ),
                SizedBox(height: 6),
                CommonTextWidget.PoppinsMedium(
                  text: "My Trips",
                  color: AppColors.greyAAA,
                  fontSize: 12,
                ),
              ],
            ),
            Obx(
              () => Column(
                children: [
                  InkWell(
                    enableFeedback: false,
                    onTap: () {
                      navigationController.pageIndex.value = 2;
                    },
                    child: SvgPicture.asset(
                      navigationController.pageIndex.value == 2
                          ? selectedRightArrow
                          : unSelectedRightArrow,
                    ),
                  ),
                  SizedBox(height: 6),
                  CommonTextWidget.PoppinsMedium(
                    text: "Where2Go",
                    color: navigationController.pageIndex.value == 2
                        ? AppColors.redCA0
                        : AppColors.greyAAA,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  enableFeedback: false,
                  onTap: () {
                    Get.to(() => MyAccountScreen());
                  },
                  child: SvgPicture.asset(userIcon),
                ),
                SizedBox(height: 6),
                CommonTextWidget.PoppinsMedium(
                  text: "MY Account",
                  color: AppColors.greyAAA,
                  fontSize: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );

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
