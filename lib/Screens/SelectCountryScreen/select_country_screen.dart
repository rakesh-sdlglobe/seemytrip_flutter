import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Controller/select_country_controller.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';

class SelectCountryScreen extends StatelessWidget {
  SelectCountryScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60),
              TextFormField(
                keyboardType: TextInputType.text,
                cursorColor: black2E2,
                controller: searchController,
                style: TextStyle(
                  color: black2E2,
                  fontSize: 14,
                  fontFamily: FontFamily.PoppinsRegular,
                ),
                decoration: InputDecoration(
                  hintText: "Country Name or Code",
                  hintStyle: TextStyle(
                    color: grey929,
                    fontSize: 15,
                    fontFamily: FontFamily.PoppinsRegular,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Icon(CupertinoIcons.search, size: 28),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                  fillColor: white,
                  disabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: greyD8D, width: 1)),
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: greyD8D, width: 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: greyD8D, width: 1)),
                  enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: greyD8D, width: 1)),
                  errorBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: greyD8D, width: 1)),
                ),
              ),
              GetBuilder<DefaultThemeSelectLanguageController>(
                init: DefaultThemeSelectLanguageController(),
                builder: (controller) => ListView.builder(
                  itemCount: Lists.countryList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          controller.onIndexChange(index);
                        },
                        leading: Image.asset(
                          Lists.countryList[index]["image"],
                          height: 29,
                          width: 29,
                        ),
                        title: CommonTextWidget.PoppinsRegular(
                          text: Lists.countryList[index]["country"],
                          fontSize: 15,
                          color: black2E2,
                        ),
                        trailing: Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: controller.selectedIndex == index
                                      ? redCA0
                                      : grey717)),
                          alignment: Alignment.center,
                          child: controller.selectedIndex == index
                              ? Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: redCA0, shape: BoxShape.circle),
                                )
                              : SizedBox.shrink(),
                        ),
                      ),
                      Divider(
                        color: greyD8D,
                        thickness: 1,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              CommonButtonWidget.button(
                text: "CONTINUE",
                buttonColor: redCA0,
                onTap: () {},
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
