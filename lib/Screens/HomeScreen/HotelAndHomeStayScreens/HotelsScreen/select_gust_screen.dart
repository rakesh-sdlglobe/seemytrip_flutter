import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/common_textfeild_widget.dart';

class SelectGuestScreen extends StatelessWidget {
  SelectGuestScreen({Key? key}) : super(key: key);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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
          child: Icon(Icons.cancel, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Select Guests",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            CommonTextWidget.PoppinsSemiBold(
              text: "Add new Guest",
              color: black2E2,
              fontSize: 16,
            ),
            CommonTextWidget.PoppinsRegular(
              text: "Name should be per official govt. ID & travelers below 18 "
                  "years od age cannot travel alone.",
              color: black2E2,
              fontSize: 12,
            ),
            SizedBox(height: 15),
            Container(
              width: Get.width,
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
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextWidget.PoppinsRegular(
                      text: "NAME AS PER PASSPORT",
                      color: grey717,
                      fontSize: 14,
                    ),
                    SizedBox(height: 10),
                    Row(
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
                                  SvgPicture.asset(arrowDownIcon,
                                      color: black2E2),
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
                    SizedBox(height: 20),
                    Image.asset(selectGuestImage, height: 20),
                  ],
                ),
              ),
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: "DONE",
              onTap: () {},
              buttonColor: redCA0,
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
