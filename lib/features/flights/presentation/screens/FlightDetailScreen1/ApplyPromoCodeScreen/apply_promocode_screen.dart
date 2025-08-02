import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/shared/constants/font_family.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class ApplyPromoCodeScreen extends StatelessWidget {
  ApplyPromoCodeScreen({Key? key}) : super(key: key);
  final TextEditingController promoCodeController = TextEditingController();

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
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Apply Promo Code",
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
                    borderSide: BorderSide(color: redCA0, width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: redCA0, width: 1)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: Lists.promoCodeList.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: whiteF2F,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.circle_outlined, color: grey959),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: Lists.promoCodeList[index]["text1"],
                                    color: black2E2,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsRegular(
                                    text: Lists.promoCodeList[index]["text2"],
                                    color: black2E2,
                                    fontSize: 10,
                                  ),
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: "T&Cs apply",
                                    color: redCA0,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(tagIcon),
                          ],
                        ),
                      ),
                    ),
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
