import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/allow_location_access_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';

class SearchCityScreen extends StatelessWidget {
  SearchCityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: redFAE.withOpacity(0.6),
                border: Border.all(color: redCA0, width: 1),
              ),
              child: ListTile(
                horizontalTitleGap: -7,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: black2E2, size: 20),
                ),
                title: CommonTextWidget.PoppinsMedium(
                  text: "City/Area/Landmark/Property/Name",
                  color: redCA0,
                  fontSize: 12,
                ),
                subtitle: CommonTextWidget.PoppinsRegular(
                  text: "Enter City/Area/Property Name",
                  color: grey717,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 32),
          ListTile(
            onTap: () {
              Get.bottomSheet(
                AllowLocationAccessScreen(),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            },
            horizontalTitleGap: -7,
            leading: SvgPicture.asset(crosshair),
            title: CommonTextWidget.PoppinsMedium(
              text: "USE CURRENT LOCATION",
              color: grey717,
              fontSize: 14,
            ),
            subtitle: CommonTextWidget.PoppinsRegular(
              text: "Using GPS",
              color: black2E2,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            horizontalTitleGap: -7,
            leading: SvgPicture.asset(recentSearchesIcon),
            title: CommonTextWidget.PoppinsMedium(
              text: "Recent Searches",
              color: grey717,
              fontSize: 14,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: grey515.withOpacity(0.25),
                      blurRadius: 16,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child: Column(
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: "Goa",
                        color: black2E2,
                        fontSize: 14,
                      ),
                      CommonTextWidget.PoppinsRegular(
                        text: "India",
                        color: grey717,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          ListTile(
            horizontalTitleGap: -7,
            leading: SvgPicture.asset(trendArrow, color: grey717),
            title: CommonTextWidget.PoppinsMedium(
              text: "Recent Searches",
              color: grey717,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 65,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 24, right: 9),
              shrinkWrap: true,
              itemCount: Lists.citySearchRecentSearchesList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 15, top: 5, bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: grey515.withOpacity(0.25),
                        blurRadius: 16,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: Column(
                      children: [
                        CommonTextWidget.PoppinsRegular(
                          text: Lists.citySearchRecentSearchesList[index],
                          color: black2E2,
                          fontSize: 14,
                        ),
                        CommonTextWidget.PoppinsRegular(
                          text: "India",
                          color: grey717,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
