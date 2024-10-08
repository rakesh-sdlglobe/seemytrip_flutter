import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_and_homestay.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/HotelAndHomeStayScreens/HotelsScreen/hotel_detail_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

class HotelScreen extends StatelessWidget {
  HotelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
      body: Column(
        children: [
          Container(
            height: 155,
            width: Get.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(hotelAndHomeStayTopImage),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListTile(
                        horizontalTitleGap: -5,
                        leading: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child:
                              Icon(Icons.arrow_back, color: grey888, size: 20),
                        ),
                        title: CommonTextWidget.PoppinsMedium(
                          text: "Goa",
                          color: black2E2,
                          fontSize: 15,
                        ),
                        subtitle: CommonTextWidget.PoppinsRegular(
                          text: "29 Sep - 30 Sep, 1 Room, 2...",
                          color: grey717,
                          fontSize: 12,
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Get.to(() => HotelAndHomeStay());
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(draw),
                              SizedBox(height: 10),
                              CommonTextWidget.PoppinsMedium(
                                text: "Edit",
                                color: redCA0,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, color: redCA0),
                              CommonTextWidget.PoppinsMedium(
                                text: "Map",
                                color: redCA0,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            width: Get.width,
            color: white,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 24, right: 19, top: 1, bottom: 10),
              shrinkWrap: true,
              itemCount: Lists.hotelList1.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 5),
                child: InkWell(
                  onTap: Lists.hotelList1[index]["onTap"],
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: white,
                      border: Border.all(color: greyE2E, width: 1),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Row(
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: Lists.hotelList1[index]["text"],
                            color: grey717,
                            fontSize: 12,
                          ),
                          SizedBox(width: 7),
                          SvgPicture.asset(arrowDownIcon, color: grey717),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                itemCount: Lists.hotelList2.length,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => HotelDetailScreen());
                    },
                    child: Image.asset(
                      Lists.hotelList2[index],
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
