import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../payment/select_payment_method_screen.dart';
import '../../../../shared/presentation/controllers/seats_meals_addone_controller.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/constants/images.dart';
import 'add_one_screen.dart';
import 'meals_screen.dart';
import 'seats.dart';
import 'seats_screen.dart';
import '../../../../../core/widgets/common_text_widget.dart';

class SeatsMealsAddOneTabScreen extends StatelessWidget {
  SeatsMealsAddOneTabScreen({Key? key}) : super(key: key);
  final SeatsMealsAddOneTabController seatsMealsAddOneTabController =
      Get.put(SeatsMealsAddOneTabController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,
                width: Get.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(flightSearch2TopImage),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                              seatSelected.value = false;
                            },
                            child: Icon(Icons.arrow_back,
                                color: AppColors.white, size: 20),
                          ),
                          SizedBox(width: 25),
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'Add-ons',
                            fontSize: 18,
                          ),
                        ],
                      ),
                      CommonTextWidget.PoppinsMedium(
                        text: 'Skip To Payment',
                        color: AppColors.white,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: seatsMealsAddOneTabController.controller,
                  children: [
                    SeatsScreen(),
                    MealsScreen(),
                    AddOneScreen(),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 110, left: 24, right: 24),
            child: Container(
              height: 45,
              width: Get.width,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grey757.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.only(left: 0, bottom: 7, right: 0),
                tabs: seatsMealsAddOneTabController.myTabs,
                unselectedLabelColor: AppColors.grey5F5,
                labelStyle:
                    TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),
                unselectedLabelStyle:
                    TextStyle(fontFamily: 'PoppinsMedium', fontSize: 14),
                labelColor: AppColors.redCA0,
                controller: seatsMealsAddOneTabController.controller,
                indicatorColor: AppColors.redCA0,
                indicatorWeight: 2.5,
              ),
            ),
          ),
          Positioned(
            bottom: 42,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              width: Get.width,
              color: AppColors.black2E2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        SvgPicture.asset(info),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {
                        // log(Lists.seatsList2.length.toString());
                        Get.to(() => SelectPaymentMethodScreen());
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
        ],
      ),
    );
}
