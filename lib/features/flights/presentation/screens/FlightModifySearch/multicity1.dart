import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/shared/constants/images.dart';
import 'package:seemytrip/features/flights/presentation/screens/flight_book_screen.dart';
import 'package:seemytrip/core/widgets/common_button_widget.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class MulticityScreen1 extends StatelessWidget {
  MulticityScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: 'FROM',
                        fontSize: 14,
                        color: AppColors.grey888,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xffE2E2E2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: 'DEL',
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              CommonTextWidget.PoppinsRegular(
                                text: 'New Delhi',
                                fontSize: 12,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xffE2E2E2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: 'BOM',
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              CommonTextWidget.PoppinsRegular(
                                text: 'Mumbai',
                                fontSize: 12,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: 'TO',
                        fontSize: 14,
                        color: AppColors.grey888,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xffE2E2E2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: 'BOM',
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              CommonTextWidget.PoppinsRegular(
                                text: 'Mumbai',
                                fontSize: 12,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xfffbecef),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: 'TO',
                                fontSize: 16,
                                color: AppColors.redCA0,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsMedium(
                        text: 'DATE',
                        fontSize: 14,
                        color: AppColors.grey888,
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Color(0xffE2E2E2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: '22 SEP',
                                fontSize: 16,
                                color: AppColors.black,
                              ),
                              CommonTextWidget.PoppinsRegular(
                                text: 'Thu, 2022',
                                fontSize: 12,
                                color: AppColors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Container(
                            height: 55,
                            width: 64,
                            decoration: BoxDecoration(
                              color: AppColors.fbecef,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonTextWidget.PoppinsSemiBold(
                                    text: 'DATE',
                                    fontSize: 16,
                                    color: AppColors.redCA0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 19.37),
                          CommonTextWidget.PoppinsRegular(
                            text: 'x',
                            fontSize: 30,
                            color: AppColors.black,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Image.asset(
                dotRectengle,
              ),
            ),
            // Image.asset(
            //   dotRectengle,
            // ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.grey9B9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: AppColors.greyE2E),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  child: Row(
                    children: [
                      SvgPicture.asset(user),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: 'TRAVELLERS & CLASS',
                            color: AppColors.grey888,
                            fontSize: 14,
                          ),
                          Row(
                            children: [
                              CommonTextWidget.PoppinsSemiBold(
                                text: '1,',
                                color: AppColors.black2E2,
                                fontSize: 18,
                              ),
                              CommonTextWidget.PoppinsMedium(
                                text: 'TEconomy/Premium Economy',
                                color: AppColors.grey888,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonTextWidget.PoppinsMedium(
                text: 'SPECIAL FARES (OPTIONAL)',
                color: AppColors.grey888,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 70,
              width: Get.width,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                  itemCount: Lists.flightSearchList2.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 12),
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.white,
                        border: Border.all(color: AppColors.greyE2E, width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CommonTextWidget.PoppinsMedium(
                            text: Lists.flightSearchList2[index],
                            color: AppColors.grey5F5,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 143),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CommonButtonWidget.button(
                buttonColor: AppColors.redCA0,
                onTap: () {
                  Get.to(() => FlightBookScreen());
                },
                text: 'MODIFY SEARCH',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
}
