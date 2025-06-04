import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/HomeScreen/VisaServicesScreen/enter_destination_screen.dart';
import 'package:seemytrip/Screens/HomeScreen/VisaServicesScreen/get_visa_online_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/common_textfeild_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class ApplyTouristVisaScreen extends StatelessWidget {
  ApplyTouristVisaScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 130,
                    width: Get.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(holidayPackagesImage),
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
                            child:
                                Icon(Icons.arrow_back, color: white, size: 20),
                          ),
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Apply Tourist Visa",
                            color: white,
                            fontSize: 18,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => EnterDestinationScreen());
                            },
                            child: CommonTextWidget.PoppinsMedium(
                              text: "City",
                              color: white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsRegular(
                      text: "Our Top Destinations",
                      color: black2E2,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: CommonTextWidget.PoppinsMedium(
                      text: "Tourist Visas only",
                      color: redCA0,
                      fontSize: 12,
                    ),
                  ),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 15,
                      childAspectRatio:
                          MediaQuery.of(context).size.aspectRatio * 2 / 1.6,
                    ),
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 15, left: 24, right: 75, bottom: 5),
                    itemCount: Lists.applyTouristList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(GetVisaOnlineScreen());
                        },
                        child: Image.asset(Lists.applyTouristList[index]),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 110, left: 24, right: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: grey515.withOpacity(0.25),
                        blurRadius: 6,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CommonTextFieldWidget.TextFormField2(
                    keyboardType: TextInputType.text,
                    controller: searchController,
                    hintText: "Enter Destination County/City",
                    prefixIcon: Icon(CupertinoIcons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
