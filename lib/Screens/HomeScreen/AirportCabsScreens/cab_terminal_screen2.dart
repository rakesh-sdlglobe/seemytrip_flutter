import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Controller/cab_terminal2_controller.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/common_textfeild_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class CabTerminalScreen2 extends StatelessWidget {
  CabTerminalScreen2({Key? key}) : super(key: key);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(cabTerminalImage1),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 55),
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
                        text: "Terminal 1C to Delhi...",
                        color: white,
                        fontSize: 18,
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 52,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xffE2E2E2),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsRegular(
                                text: "SHEDULED PICKUP",
                                fontSize: 12,
                                color: Color(0xff717171),
                              ),
                              SizedBox(height: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: "11 oct,",
                                    fontSize: 15,
                                    color: black2E2,
                                  ),
                                  CommonTextWidget.PoppinsRegular(
                                    text: "10:00 AM",
                                    fontSize: 12,
                                    color: grey717,
                                  )
                                ],
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                color: redCA0,
                              ),
                              SizedBox(height: 1),
                              CommonTextWidget.PoppinsMedium(
                                text: "Edit",
                                fontSize: 15,
                                color: redCA0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 25,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: grey9B9.withOpacity(0.15),
                    border: Border.all(color: greyE2E, width: 1),
                  ),
                  child: Center(
                    child: CommonTextWidget.PoppinsMedium(
                      text:
                          "Distance for selected route is 9kms | Approx 0.5 hr(s)",
                      color: grey575,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 5),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(cabTerminalImage3),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 5),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Cab & Driver Details",
                  color: black2E2,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsMedium(
                  text:
                      "QR Code & MMT Affiliate Counter details will be shared "
                      "after Booking.",
                  color: black2E2,
                  fontSize: 11,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsMedium(
                  text:
                      "Show your booking details at MMt Afilitate Counter at the "
                      "Airport and quickly into a cab.",
                  color: black2E2,
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Cab Images",
                  color: black2E2,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: yellowF7C.withOpacity(0.35),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: CommonTextWidget.PoppinsMedium(
                      text: "These are only representative images.",
                      color: black2E2,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Image.asset(cabTerminal2Image1, height: 80, width: 80),
                    SizedBox(width: 12),
                    Image.asset(cabTerminal2Image2, height: 80, width: 80),
                    SizedBox(width: 12),
                    Image.asset(cabTerminal2Image3, height: 80, width: 80),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Cab & Driver Details",
                  color: black2E2,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsMedium(
                        text:
                            "Airport Entry Charges and Driver Allowance are included",
                        color: black2E2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsMedium(
                        text: "9 kms included Fare beyound 9 Kms : ₹18/Km ",
                        color: black2E2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Space for 2 Luggage Bags - More luggage can be "
                            "adjusted in seating ares with driver consent.",
                        color: black2E2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, color: black2E2, size: 10),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextWidget.PoppinsMedium(
                        text: "Cancellation info "
                            "\nTill 11 Oct 10:00 AM - Free "
                            "\nAfter 11 Oct 10:00 AM - 100% penalty",
                        color: black2E2,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 5),
              SizedBox(height: 14),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "I am booking for",
                  color: black2E2,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: GetBuilder<CabTerminalController>(
                  init: CabTerminalController(),
                  builder: (controller) => ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    shrinkWrap: true,
                    itemCount: Lists.cabTerminal2List1.length,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              controller.onIndexChange(index);
                            },
                            child: controller.selectedIndex == index
                                ? SvgPicture.asset(selectedIcon)
                                : SvgPicture.asset(unSelectedIcon,
                                    color: greyD0D),
                          ),
                          SizedBox(width: 8),
                          CommonTextWidget.PoppinsRegular(
                            text: Lists.cabTerminal2List1[index],
                            color: black2E2,
                            fontSize: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsRegular(
                  text: "Name",
                  color: black2E2,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 40),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: grey9B9.withOpacity(0.25),
                        border: Border.all(color: greyE2E, width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              CommonTextWidget.PoppinsRegular(
                                text: "Mr.",
                                color: black2E2,
                                fontSize: 14,
                              ),
                              SizedBox(width: 5),
                              SvgPicture.asset(arrowDownIcon, color: black2E2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextFieldWidget.TextFormField6(
                        keyboardType: TextInputType.text,
                        controller: firstNameController,
                        hintText: "First Name",
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CommonTextFieldWidget.TextFormField6(
                        keyboardType: TextInputType.text,
                        controller: lastNameController,
                        hintText: "Last Name",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsRegular(
                  text: "Email",
                  color: black2E2,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 40),
                child: CommonTextFieldWidget.TextFormField6(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: "Enter Email",
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsRegular(
                  text: "Contact No",
                  color: black2E2,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 40),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: grey9B9.withOpacity(0.25),
                        border: Border.all(color: greyE2E, width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              CommonTextWidget.PoppinsRegular(
                                text: "+91.",
                                color: black2E2,
                                fontSize: 14,
                              ),
                              SizedBox(width: 5),
                              SvgPicture.asset(arrowDownIcon, color: black2E2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: CommonTextFieldWidget.TextFormField6(
                        keyboardType: TextInputType.text,
                        controller: firstNameController,
                        hintText: "9758******",
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: greyE8E, thickness: 5),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonTextWidget.PoppinsSemiBold(
                  text: "Payment options",
                  color: black2E2,
                  fontSize: 18,
                ),
              ),
              GetBuilder<CabTerminalController>(
                init: CabTerminalController(),
                builder: (controller) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: Lists.cabTerminal2List2.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: -5,
                    leading: InkWell(
                      onTap: () {
                        controller.onIndexChange1(index);
                      },
                      child: controller.selectedIndex1 == index
                          ? SvgPicture.asset(selectedIcon)
                          : SvgPicture.asset(unSelectedIcon, color: greyD0D),
                    ),
                    title: CommonTextWidget.PoppinsMedium(
                      text: Lists.cabTerminal2List2[index]["text1"],
                      color: black2E2,
                      fontSize: 14,
                    ),
                    trailing: CommonTextWidget.PoppinsMedium(
                      text: Lists.cabTerminal2List2[index]["text2"],
                      color: black2E2,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: RichText(
                  text: TextSpan(
                    text: "By proceeding. I agree to MakeMyTrip’s ",
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsRegular,
                      fontSize: 12,
                      color: grey969,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "User Agrement. Terms of service ",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: FontFamily.PoppinsRegular,
                            color: blue1F9),
                      ),
                      TextSpan(
                        text: "and ",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: FontFamily.PoppinsRegular,
                            color: grey969),
                      ),
                      TextSpan(
                        text: "Cancellation & Property Booking Policies",
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: FontFamily.PoppinsRegular,
                            color: blue1F9),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CommonButtonWidget.button(
                  text: "Next",
                  onTap: () {},
                  buttonColor: redCA0,
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
