import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/main.dart';

class OfferMakeYourTripScreen extends StatelessWidget {
  OfferMakeYourTripScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "MakeYourTrip",
          color: white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(offerMakeYourTripImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: Get.width,
                color: redF9E,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text:
                            "Flate 13% off up to Rs.1500 on your first flight booking.",
                        color: black2E2,
                        fontSize: 14,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          CommonTextWidget.PoppinsRegular(
                            text: "Use Code:",
                            color: grey888,
                            fontSize: 12,
                          ),
                          CommonTextWidget.PoppinsMedium(
                            text: " WELCOMEMMT",
                            color: redCA0,
                            fontSize: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      MaterialButton(
                        onPressed: () {},
                        height: 30,
                        minWidth: 99,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: redCA0,
                        child: CommonTextWidget.PoppinsRegular(
                          fontSize: 12,
                          text: "BOOK NOW",
                          color: white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsMedium(
                  fontSize: 14,
                  text: "Offer Details:",
                  color: black2E2,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Table(
                  border: TableBorder(
                    bottom: BorderSide(color: greyE2E, width: 1),
                    top: BorderSide(color: greyE2E, width: 1),
                    left: BorderSide(color: greyE2E, width: 1),
                    right: BorderSide(color: greyE2E, width: 1),
                    verticalInside: BorderSide(color: greyE2E, width: 1),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: black2E2.withOpacity(0.7),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 15, bottom: 5),
                          child: CommonTextWidget.PoppinsMedium(
                            text: "Coupon Code",
                            color: white,
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 30, bottom: 5),
                          child: CommonTextWidget.PoppinsMedium(
                            text: "Category",
                            color: white,
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, left: 20, bottom: 5),
                          child: CommonTextWidget.PoppinsMedium(
                            text: "Offer Details",
                            color: white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 35, left: 15),
                          child: CommonTextWidget.PoppinsMedium(
                            text: "WELCOMEMMT",
                            color: redCA0,
                            fontSize: 12,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 15, right: 15, bottom: 20),
                          child: CommonTextWidget.PoppinsRegular(
                            text: "Domestic Flights",
                            color: grey888,
                            fontSize: 12,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20, left: 15, right: 15, bottom: 20),
                          child: CommonTextWidget.PoppinsRegular(
                            text: "Get FLAT 13% up to Rs. 1500 OFF",
                            color: grey888,
                            fontSize: 12,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsRegular(
                        text:
                            "Get FLAT 13% up to Rs. 1500 OFF on your first flight booking!",
                        color: black2E2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsRegular(
                        text:
                            "This coupon is valid only on your first domestic flight booking on MMT.",
                        color: black2E2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsRegular(
                        text:
                            "On the application of the dealcode WELCOMEMMT, discount will automatically decuted amount.",
                        color: black2E2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
