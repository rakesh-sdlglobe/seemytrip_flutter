import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../features/trips/presentation/controllers/my_trip_controller.dart';
import '../../../../../features/trips/presentation/screens/my_trips/cancelled_trip_screen.dart';
import '../../../../../features/trips/presentation/screens/my_trips/upcoming_trip_screen.dart';
import '../../../../../shared/constants/images.dart';

class MyTripScreen extends StatelessWidget {
  MyTripScreen({Key? key}) : super(key: key);

  final MyTripTabController myTripTabController =
      Get.put(MyTripTabController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.whiteF2F,
      appBar: AppBar(
        backgroundColor: AppColors.whiteF2F,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.black2E2, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'My Trips',
          color: AppColors.black2E2,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 16, right: 24),
            child: SvgPicture.asset(arrowCounterClockwise),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 45,
            width: Get.width,
            decoration: BoxDecoration(
              color: AppColors.whiteF2F,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey363.withValues(alpha: 0.25),
                  blurRadius: 4,
                ),
              ],
            ),
            child: TabBar(
              isScrollable: true,
              padding: EdgeInsets.only(left: 24, bottom: 7, right: 10),
              tabs: myTripTabController.myTabs,
              unselectedLabelColor: AppColors.grey5F5,
              labelStyle:
                  TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),
              unselectedLabelStyle:
                  TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14),
              labelColor: AppColors.redCA0,
              controller: myTripTabController.controller,
              indicatorColor: AppColors.redCA0,
              indicatorWeight: 2.5,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: myTripTabController.controller,
              children: [
                UpComingTripScreen(),
                CancelledTripScreen(),
                Scaffold(),
                Scaffold(),
              ],
            ),
          ),
        ],
      ),
    );
}
