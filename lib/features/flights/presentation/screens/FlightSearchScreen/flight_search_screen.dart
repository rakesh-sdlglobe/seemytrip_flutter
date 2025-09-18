import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
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
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: white,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 155,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(flightSearchTopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back, color: white, size: 20),
                      ),
                      CommonTextWidget.PoppinsSemiBold(
                        text: 'Flight Search',
                        color: white,
                        fontSize: 18,
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: redF9E,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(offerIcon),
                        SizedBox(width: 10),
                        Expanded(
                          child: CommonTextWidget.PoppinsMedium(
                            text:
                                'Get FLAT 13% OFF* on your first booking! use '
                                'code: WELCOMEMMT',
                            color: redCA0,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Expanded(
                child: GetBuilder<FlightSearchController>(
                  builder: (controller) {
                    if (!controller.isControllerInitialized) {
                      return const Center(child: CircularProgressIndicator());
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
              SizedBox(height: 30),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 130, left: 24, right: 24),
            child: Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: grey757.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: GetBuilder<FlightSearchController>(
                builder: (controller) {
                  if (!controller.isControllerInitialized) {
                    return const SizedBox.shrink();
                  }
                  return TabBar(
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    padding: const EdgeInsets.only(left: 24, bottom: 7, right: 10),
                    tabs: controller.myTabs,
                    unselectedLabelColor: grey5F5,
                    labelStyle: const TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14),
                    labelColor: redCA0,
                    controller: controller.tabController,
                    onTap: (index) {
                      controller.tabController.animateTo(index);
                    },
                    indicatorColor: redCA0,
                    indicatorWeight: 2.5,
                  );
                },
              ),
            ),
          ),
          // Positioned(
          //   right: 32,
          //   top: 335,
          //   child: InkWell(
          //     onTap: () {
          //       // Get.to(() => SortAndFilterScreen());
          //     },
          //     child: Container(
          //       height: 45,
          //       width: 33,
          //       decoration: BoxDecoration(
          //         color: white,
          //         borderRadius: BorderRadius.circular(4),
          //         border: Border.all(
          //           color: greyE2E,
          //           width: 1,
          //         ),
          //       ),
          //       child: Center(
          //         child: SvgPicture.asset(arrowsDownUp),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
}
