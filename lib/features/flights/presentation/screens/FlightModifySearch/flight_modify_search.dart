import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/features/flights/presentation/controllers/flight_modify_search_controller.dart';
import 'package:seemytrip/features/flights/presentation/screens/FlightModifySearch/round_trip1.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'multicity1.dart';
import 'one_way_screen1.dart';

class FlightModifySearch extends StatelessWidget {
  FlightModifySearch({Key? key}) : super(key: key);

  final FlightModifySearchController flightModifySearchController =
      Get.put(FlightModifySearchController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back, color: white, size: 20),
                      ),
                      CommonTextWidget.PoppinsSemiBold(
                        text: "Modify Flight Search",
                        color: white,
                        fontSize: 18,
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: TabBarView(
                  controller: flightModifySearchController.controller,
                  children: [
                    OneWayScreen1(),
                    RoundTripScreen1(),
                    MulticityScreen1(),
                  ],
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
                boxShadow: [
                  BoxShadow(
                    color: grey757.withOpacity(0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.only(left: 24, bottom: 7, right: 10),
                tabs: flightModifySearchController.myTabs,
                unselectedLabelColor: grey5F5,
                labelStyle:
                    TextStyle(fontFamily: "PoppinsSemiBold", fontSize: 14),
                unselectedLabelStyle:
                    TextStyle(fontFamily: "PoppinsMedium", fontSize: 14),
                labelColor: redCA0,
                controller: flightModifySearchController.controller,
                indicatorColor: redCA0,
                indicatorWeight: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
