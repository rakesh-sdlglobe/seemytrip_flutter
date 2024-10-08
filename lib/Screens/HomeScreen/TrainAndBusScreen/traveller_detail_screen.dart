import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Screens/Utills/common_button_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';

class TravellerDetailScreen extends StatelessWidget {
  TravellerDetailScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

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
          text: "Traveller Details",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Name",
              color: grey717,
              fontSize: 12,
            ),
            SizedBox(height: 5),
            CommonTextFieldWidget.TextFormField5(
              hintText: "Enter Full Name",
              controller: nameController,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: "Age",
                        color: grey717,
                        fontSize: 12,
                      ),
                      SizedBox(height: 5),
                      CommonTextFieldWidget.TextFormField5(
                        hintText: "Enter age",
                        controller: ageController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: "Gender",
                        color: grey717,
                        fontSize: 12,
                      ),
                      Container(
                        height: 44,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: grey717, width: 1),
                          color: white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonTextWidget.PoppinsMedium(
                                text: "Male",
                                color: grey717,
                                fontSize: 12,
                              ),
                              Container(
                                height: 44,
                                width: 1,
                                color: grey717,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: "Female",
                                color: grey717,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Berth preference",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 4),
            CommonTextWidget.PoppinsRegular(
              text: "Selecting a berth preference does not guarantee "
                  "allotment of preferred berth.",
              color: grey717,
              fontSize: 12,
            ),
            SizedBox(height: 20),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                crossAxisSpacing: 40,
                childAspectRatio:
                    MediaQuery.of(context).size.aspectRatio * 2 / 0.2,
              ),
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: Lists.trainAndBusTravellerDetailList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Icon(Icons.circle_outlined, color: grey717),
                    SizedBox(width: 12),
                    CommonTextWidget.PoppinsRegular(
                      text: Lists.trainAndBusTravellerDetailList[index],
                      color: black2E2,
                      fontSize: 14,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            CommonTextWidget.PoppinsMedium(
              text: "Nationality",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 8),
            CommonTextFieldWidget.TextFormField5(
              hintText: "INDIAN",
              controller: nationalityController,
              keyboardType: TextInputType.text,
            ),
            Spacer(),
            CommonButtonWidget.button(
              text: "SAVE",
              buttonColor: greyBEB,
              onTap: (){},
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
