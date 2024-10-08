import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/review_booking_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_contact_information_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/traveller_detail_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';

class TrainAndBusSearchScreen2 extends StatelessWidget {
  TrainAndBusSearchScreen2({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redF9E,
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
          text: "Train Search",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    color: white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: "Hwg Duronto Exp",
                                color: black2E2,
                                fontSize: 14,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "#12568",
                                color: greyB8B,
                                fontSize: 14,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: "12:40 PM",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "4 Oct",
                                    color: greyB8B,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 2,
                                    width: 30,
                                    color: greyDBD,
                                  ),
                                  SizedBox(width: 15),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "21h 55m",
                                    color: grey717,
                                    fontSize: 12,
                                  ),
                                  SizedBox(width: 15),
                                  Container(
                                    height: 2,
                                    width: 30,
                                    color: greyDBD,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: "10:35 AM",
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: "5 Oct",
                                    color: greyB8B,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: "New Delhi "
                                    "\n(NDLS)",
                                color: grey717,
                                fontSize: 12,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "Howrah JN "
                                    "\n(HWH)",
                                color: grey717,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    color: white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "IRCTC Username",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                TrainAndBusContactInformationScreen(),
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                              );
                            },
                            child: Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: greyE2E,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: CommonTextWidget.PoppinsMedium(
                                  text: "USERNAME",
                                  color: grey888,
                                  fontSize: 12,
                                ),
                                subtitle: CommonTextWidget.PoppinsMedium(
                                  text: "Enter IRCTC Username",
                                  color: grey888,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          CommonTextWidget.PoppinsMedium(
                            text: "CREATE NEW IRCTC ACCOUNT",
                            color: redCA0,
                            fontSize: 12,
                          ),
                          SizedBox(height: 10),
                          CommonTextWidget.PoppinsMedium(
                            text: "FORGOT USERNAME",
                            color: redCA0,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    color: white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Traveller Details",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: yellowF7C.withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: CommonTextWidget.PoppinsMedium(
                                text: "You do not have any saved travellers",
                                color: yellowCE8,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Get.to(() => TravellerDetailScreen());
                            },
                            child: CommonTextWidget.PoppinsMedium(
                              text: "+ TRAVELLER DETAILS",
                              color: redCA0,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    color: white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Contact Details",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 15),
                          CommonTextWidget.PoppinsMedium(
                            text: "Email ID",
                            color: grey717,
                            fontSize: 12,
                          ),
                          SizedBox(height: 5),
                          CommonTextFieldWidget.TextFormField4(
                            hintText: "Eg. abc@gmail.com",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 15),
                          CommonTextWidget.PoppinsMedium(
                            text: "Phone Number",
                            color: grey717,
                            fontSize: 12,
                          ),
                          SizedBox(height: 5),
                          CommonTextFieldWidget.TextFormField4(
                            hintText: "95********",
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: Get.width,
                    color: white,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Offers & Discounts",
                            color: black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.circle_outlined, color: grey717),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(zeroFeeImage,
                                      height: 20, width: 50),
                                  SizedBox(height: 7),
                                  CommonTextWidget.PoppinsRegular(
                                    text: "save Rs. 50 service fee",
                                    color: grey717,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            cursorColor: black2E2,
                            controller: promoCodeController,
                            style: TextStyle(
                              color: black2E2,
                              fontSize: 14,
                              fontFamily: FontFamily.PoppinsRegular,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter promo code here",
                              hintStyle: TextStyle(
                                color: grey717,
                                fontSize: 12,
                                fontFamily: FontFamily.PoppinsRegular,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.all(14),
                                child: CommonTextWidget.PoppinsMedium(
                                  color: redCA0,
                                  fontSize: 14,
                                  text: "APPLY",
                                ),
                              ),
                              filled: true,
                              fillColor: white,
                              contentPadding: EdgeInsets.only(left: 14),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: grey717, width: 1)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: grey717, width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: grey717, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: grey717, width: 1)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: grey717, width: 1)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 130),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 60,
                    width: Get.width,
                    color: black2E2,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: "₹ 575",
                                color: white,
                                fontSize: 16,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "PER PERSON",
                                color: white,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          MaterialButton(
                            onPressed: () {
                              Get.to(() => ReviewBookingScreen());
                            },
                            height: 40,
                            minWidth: 140,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: redCA0,
                            child: CommonTextWidget.PoppinsSemiBold(
                              fontSize: 16,
                              text: "CONTINUE",
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
