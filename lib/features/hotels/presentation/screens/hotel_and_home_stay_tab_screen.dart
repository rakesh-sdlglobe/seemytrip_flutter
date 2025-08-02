import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/common/common_app_bar.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/utils/colors.dart';
import '../../../../shared/constants/images.dart';
import '../controllers/hotel_and_homestay_controller.dart';
import '../controllers/hotel_controller.dart';
import 'hotel_home_screen.dart';

class HotelAndHomeStayTabScreen extends StatelessWidget {
  HotelAndHomeStayTabScreen({Key? key}) : super(key: key);

  final HotelAndHomeStayTabController hotelAndHomeStayTabController =
      Get.put(HotelAndHomeStayTabController());
  final SearchCityController searchCityController = Get.put(SearchCityController());
 
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Column(
            children: [
              CommonAppBar(
                title: 'Hotels',
                showBackButton: true,
                // height: 255,
              ),
              Expanded(child: HotelHomeScreen()),
              // Expanded(
              //   child: TabBarView(
              //     controller: hotelAndHomeStayTabController.controller,
              //     children: [
              //       UpTo5RoomsScreen(),
              //       FivePlusRoomsScreen(),
              //     ],
              //   ),
              // ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 130, left: 24, right: 24),
          //   child: Container(
          //     height: 45,
          //     width: Get.width,
          //     decoration: BoxDecoration(
          //       color: white,
          //       borderRadius: BorderRadius.circular(5),
          //       boxShadow: [
          //         BoxShadow(
          //           color: grey757.withOpacity(0.25),
          //           blurRadius: 6,
          //           offset: Offset(0, 1),
          //         ),
          //       ],
          //     ),
          //     // child: TabBar(
          //     //   indicatorSize: TabBarIndicatorSize.label,
          //     //   padding: EdgeInsets.only(bottom: 7),
          //     //   tabs: hotelAndHomeStayTabController.myTabs,
          //     //   unselectedLabelColor: grey5F5,
          //     //   labelStyle:
          //     //       TextStyle(fontFamily: "PoppinsSemiBold", fontSize: 14),
          //     //   unselectedLabelStyle:
          //     //       TextStyle(fontFamily: "PoppinsMedium", fontSize: 14),
          //     //   labelColor: redCA0,
          //     //   controller: hotelAndHomeStayTabController.controller,
          //     //   indicatorColor: redCA0,
          //     //   indicatorWeight: 2.5,
          //     // ),
          //   ),
          // ),
        ],
      ),
    );
}

// Create a separate widget for the tab view content
// class TabViewContent extends GetView<SearchCityController> {
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => TabBarView(
//       controller: Get.find<HotelAndHomeStayTabController>().controller,
//       children: [
//         UpTo5RoomsScreen(),
//         FivePlusRoomsScreen(),
//       ],
//     ));
//   }
// }
