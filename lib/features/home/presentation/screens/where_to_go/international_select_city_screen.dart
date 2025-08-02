import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class InternationalSelectCityScreenScreen extends StatelessWidget {
  InternationalSelectCityScreenScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: 65),
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
              child: TextFormField(
                keyboardType: TextInputType.text,
                cursorColor: black2E2,
                controller: searchController,
                style: TextStyle(
                  color: black2E2,
                  fontSize: 14,
                  fontFamily: FontFamily.PoppinsRegular,
                ),
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back, color: grey717),
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(15),
                    child: CommonTextWidget.PoppinsMedium(
                      color: redCA0,
                      text: "Clear",
                      fontSize: 12,
                    ),
                  ),
                  hintText: "Select Your City",
                  hintStyle: TextStyle(
                    color: greyA1A,
                    fontSize: 15,
                    fontFamily: FontFamily.PoppinsRegular,
                  ),
                  filled: true,
                  fillColor: white,
                  contentPadding: EdgeInsets.only(left: 12),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: white, width: 0)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: white, width: 0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: white, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: white, width: 0)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: white, width: 0)),
                ),
              ),
            ),
            SizedBox(height: 20),
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: Lists.internationalSelectCityList.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: CommonTextWidget.PoppinsRegular(
                    color: grey717,
                    text: Lists.internationalSelectCityList[index],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
