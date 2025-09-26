import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/doted_screen.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../../shared/constants/images.dart';
import '../FlightDetailScreen/review_detail_screen.dart';
import 'AddTravellerScreen/add_traveller_screen.dart';
import 'ApplyPromoCodeScreen/apply_promocode_screen.dart';
import 'CheckInBaggageScreen/check_in_baggage_screen.dart';
import 'FareBreakUpScreen1/fare_break_up_screen1.dart';
import 'RefundPolicyScreen/refund_policy_tab_screen.dart';
import 'contact_information_screen.dart';
import 'gst_information_screen.dart';

class FlightDetailScreen1 extends StatelessWidget {
  FlightDetailScreen1({Key? key}) : super(key: key);

  final TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.redF9E,
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(flightDetail1Image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 75, left: 24, right: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.arrow_back,
                                    color: AppColors.whiteF2F, size: 24),
                              ),
                              Column(
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: 'Trip to',
                                    color: AppColors.whiteF2F,
                                    fontSize: 14,
                                  ),
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: 'Mumbai',
                                    color: AppColors.whiteF2F,
                                    fontSize: 20,
                                  ),
                                ],
                              ),
                              SizedBox.shrink(),
                            ],
                          ),
                          SizedBox(height: 25),
                          Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.whiteF2F,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Image.asset(spicejet),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonTextWidget.PoppinsSemiBold(
                                      text: 'DEL - BOM',
                                      color: AppColors.whiteF2F,
                                      fontSize: 14,
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text:
                                          'Sat, 24 Sep | 19:45 - 22.00 | 2hrs 15mins',
                                      color: AppColors.whiteF2F,
                                      fontSize: 14,
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: 'Economy > SPICESAVER',
                                      color: AppColors.whiteF2F,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Container(
                            height: 43,
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: AppColors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: AppColors.whiteF2F, width: 1),
                            ),
                            child: Center(
                              child: CommonTextWidget.PoppinsMedium(
                                text: 'VIEW FLIGHT & FARE DETAILS',
                                color: AppColors.whiteF2F,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.whiteF2F,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => RefundPolicyTabScreen());
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: 'Baggage Policy',
                                    color: AppColors.black2E2,
                                    fontSize: 16,
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: AppColors.redCA0),
                                ],
                              ),
                            ),
                            SizedBox(height: 22),
                            Table(
                              columnWidths: {
                                0: FlexColumnWidth(1.5),
                                1: FlexColumnWidth(4.5),
                                2: FlexColumnWidth(6),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10, right: 10),
                                      child: SvgPicture.asset(briefcase),
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: 'Cabin bag',
                                      color: AppColors.black2E2,
                                      fontSize: 12,
                                    ),
                                    CommonTextWidget.PoppinsRegular(
                                      text: '7 Kgs ( 1 Piece only)',
                                      color: AppColors.grey717,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 10, right: 10),
                                      child: SvgPicture.asset(backpack),
                                    ),
                                    CommonTextWidget.PoppinsMedium(
                                      text: 'Check-in',
                                      color: AppColors.black2E2,
                                      fontSize: 12,
                                    ),
                                    CommonTextWidget.PoppinsRegular(
                                      text: '15 Kgs ( 1 Piece only)',
                                      color: AppColors.grey717,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                Get.to(() => CheckInBaggageScreen());
                              },
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: AppColors.redF9E.withOpacity(0.75),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CommonTextWidget.PoppinsRegular(
                                          text:
                                              'Got excess luggage? Dont’t stress, buy '
                                              'extra check-in baggage allowance at fab '
                                              'rates!',
                                          color: AppColors.black2E2,
                                          fontSize: 10,
                                        ),
                                      ),
                                      CommonTextWidget.PoppinsSemiBold(
                                        text: '+ADD',
                                        color: AppColors.redCA0,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.whiteF2F,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsSemiBold(
                              text: 'Cancellation Refund Policy',
                              color: AppColors.black2E2,
                              fontSize: 16,
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: 'Cancel Between (IST):',
                                  color: AppColors.grey717,
                                  fontSize: 10,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: 'Cancellation Penalty:',
                                  color: AppColors.grey717,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: 'Now - 27 sep, 10:25',
                                  color: AppColors.black2E2,
                                  fontSize: 12,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: '₹ 3,900',
                                  color: AppColors.black2E2,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            MyDotSeparator(),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonTextWidget.PoppinsMedium(
                                  text: '27 Sep, 10:05 27 Sep, 12:05',
                                  color: AppColors.black2E2,
                                  fontSize: 12,
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: '₹ 6,900',
                                  color: AppColors.black2E2,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColors.redF9E.withOpacity(0.75),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CommonTextWidget.PoppinsRegular(
                                        text:
                                            'Upgrade fare to get extra legroom '
                                            'and complimentary meals',
                                        color: AppColors.black2E2,
                                        fontSize: 10,
                                      ),
                                    ),
                                    CommonTextWidget.PoppinsSemiBold(
                                      text: 'UPGRADE',
                                      color: AppColors.redCA0,
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.whiteF2F,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Get.to(() => ApplyPromoCodeScreen());
                              },
                              contentPadding: EdgeInsets.zero,
                              title: CommonTextWidget.PoppinsSemiBold(
                                text: 'Offers & Promo Codes',
                                color: AppColors.black2E2,
                                fontSize: 16,
                              ),
                              subtitle: CommonTextWidget.PoppinsRegular(
                                text: 'To help you save more',
                                color: AppColors.black2E2,
                                fontSize: 12,
                              ),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: AppColors.redCA0, size: 18),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              cursorColor: AppColors.black2E2,
                              controller: promoCodeController,
                              style: TextStyle(
                                color: AppColors.black2E2,
                                fontSize: 14,
                                fontFamily: FontFamily.PoppinsRegular,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter promo code here',
                                hintStyle: TextStyle(
                                  color: AppColors.grey717,
                                  fontSize: 12,
                                  fontFamily: FontFamily.PoppinsRegular,
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: CommonTextWidget.PoppinsMedium(
                                    color: AppColors.redCA0,
                                    fontSize: 14,
                                    text: 'APPLY',
                                  ),
                                ),
                                filled: true,
                                fillColor: AppColors.whiteF2F,
                                contentPadding: EdgeInsets.only(left: 14),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: AppColors.redCA0, width: 1)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: AppColors.redCA0, width: 1)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: AppColors.redCA0, width: 1)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: AppColors.redCA0, width: 1)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: AppColors.redCA0, width: 1)),
                              ),
                            ),
                            SizedBox(height: 15),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteF2F,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.circle_outlined,
                                            color: AppColors.grey959),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CommonTextWidget.PoppinsSemiBold(
                                                text: 'MMTSUPER',
                                                color: AppColors.black2E2,
                                                fontSize: 14,
                                              ),
                                              CommonTextWidget.PoppinsRegular(
                                                text:
                                                    'Use this coupon and get Rs 475 instant discount on your flight booking.',
                                                color: AppColors.black2E2,
                                                fontSize: 10,
                                              ),
                                              CommonTextWidget.PoppinsSemiBold(
                                                text: 'T&Cs apply',
                                                color: AppColors.redCA0,
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CommonTextWidget.PoppinsSemiBold(
                                text: 'VIEW MORE',
                                color: AppColors.redCA0,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.whiteF2F,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: -1,
                              leading:
                                  Icon(Icons.circle_outlined, color: AppColors.grey959),
                              title: CommonTextWidget.PoppinsMedium(
                                text: 'Donate ₹10 to support responsible '
                                    'tourism initiatives ',
                                color: AppColors.black2E2,
                                fontSize: 12,
                              ),
                              trailing: CommonTextWidget.PoppinsMedium(
                                text: 'T&Cs',
                                color: AppColors.redCA0,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: AppColors.redFAE,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        'Support community empowerment and preservation or heritage. ',
                                    style: TextStyle(
                                      fontFamily: FontFamily.PoppinsMedium,
                                      fontSize: 10,
                                      color: AppColors.black2E2,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Know More',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                FontFamily.PoppinsMedium,
                                            color: AppColors.redCA0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: AppColors.whiteF2F,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTextWidget.PoppinsSemiBold(
                              text: 'Traveller Details',
                              color: AppColors.black2E2,
                              fontSize: 16,
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: -1,
                              leading: Image.asset(travellerDetailsProfileImage,
                                  height: 30, width: 30),
                              title: CommonTextWidget.PoppinsSemiBold(
                                text: 'ADULT (12 yrs+)',
                                color: AppColors.black2E2,
                                fontSize: 16,
                              ),
                              trailing: RichText(
                                text: TextSpan(
                                  text: '0/1 ',
                                  style: TextStyle(
                                    fontFamily: FontFamily.PoppinsMedium,
                                    fontSize: 10,
                                    color: AppColors.black2E2,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'added',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: FontFamily.PoppinsMedium,
                                          color: AppColors.grey717),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Get.to(() => AddTravellerScreen());
                              },
                              child: Container(
                                height: 44,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.whiteF2F,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.grey4B4.withOpacity(0.25),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CommonTextWidget.PoppinsSemiBold(
                                    text: '+ Add New ADULT',
                                    color: AppColors.redCA0,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(color: AppColors.greyE8E, thickness: 1),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: (){
                                Get.bottomSheet(
                                  ContactInformationScreen(),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: 'Booking details will be sent to',
                                    color: AppColors.black2E2,
                                    fontSize: 12,
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      color: AppColors.redCA0, size: 18),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10,
                              leading: Image.asset(addEmailIdIcon),
                              title: CommonTextWidget.PoppinsMedium(
                                text: 'Add Email ID',
                                color: AppColors.redCA0,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 12),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 10,
                              leading: Image.asset(phoneImage),
                              title: CommonTextWidget.PoppinsRegular(
                                text: '91-8669825896',
                                color: AppColors.grey717,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 15),
                            Divider(color: AppColors.greyE8E, thickness: 1),
                            SizedBox(height: 10),
                            ListTile(
                              onTap: (){
                                Get.bottomSheet(
                                  GstInformationScreen(),
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              horizontalTitleGap: 1,
                              leading: Icon(Icons.crop_square,
                                  color: AppColors.grey717, size: 30),
                              title: RichText(
                                text: TextSpan(
                                  text: 'I have a GST number ',
                                  style: TextStyle(
                                    fontFamily: FontFamily.PoppinsMedium,
                                    fontSize: 12,
                                    color: AppColors.black2E2,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '(Optional)',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: FontFamily.PoppinsMedium,
                                          color: AppColors.grey717),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 110),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: Get.width,
                color: AppColors.black2E2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: '₹ 5,950',
                                color: AppColors.white,
                                fontSize: 16,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: 'FOR 1 ADULT',
                                color: AppColors.white,
                                fontSize: 10,
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              Get.to(() => FareBreakUpScreen1());
                            },
                            child: SvgPicture.asset(info),
                          ),
                        ],
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.bottomSheet(
                            ReviewDetailScreen(),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          );
                        },
                        height: 40,
                        minWidth: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        color: AppColors.redCA0,
                        child: CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: 'CONTINUE',
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
}
