import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/common_textfeild_widget.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../core/widgets/lists_widget.dart';
import '../../../../main.dart';
import '../../../../shared/constants/font_family.dart';
import '../../../../shared/constants/images.dart';
import '../../../booking/presentation/screens/payment/select_payment_method_screen.dart';
import '../../../cabs/presentation/controllers/cab_terminal2_controller.dart';
import 'coupon_code_screen.dart';
import 'select_gust_screen.dart';


class HotelReviewBookingScreen extends StatelessWidget {
  HotelReviewBookingScreen({Key? key}) : super(key: key);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Review Booking',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Image.asset(hotelReviewBookingImage1,
                    height: 438, width: Get.width),
                Image.asset(hotelReviewBookingImage2),
                InkWell(
                  onTap: () {
                    Get.to(() => CouponCodeScreen());
                  },
                  child: Image.asset(hotelReviewBookingImage3),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grey515.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: 'I am booking for',
                            color: AppColors.black2E2,
                            fontSize: 14,
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            height: 30,
                            child: GetBuilder<CabTerminalController>(
                              init: CabTerminalController(),
                              builder: (controller) => ListView.builder(
                                padding: EdgeInsets.zero,
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
                                                colorFilter: ColorFilter.mode(AppColors.greyD0D, BlendMode.srcIn)),
                                      ),
                                      SizedBox(width: 8),
                                      CommonTextWidget.PoppinsRegular(
                                        text: Lists.cabTerminal2List1[index],
                                        color: AppColors.black2E2,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          CommonTextWidget.PoppinsRegular(
                            text: 'Name',
                            color: AppColors.black2E2,
                            fontSize: 12,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.grey9B9.withValues(alpha: 0.25),
                                  border: Border.all(color: AppColors.greyE2E, width: 1),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      children: [
                                        CommonTextWidget.PoppinsRegular(
                                          text: 'Mr.',
                                          color: AppColors.black2E2,
                                          fontSize: 14,
                                        ),
                                        SizedBox(width: 5),
                                        SvgPicture.asset(arrowDownIcon,
                                            colorFilter: ColorFilter.mode(
                                                AppColors.black2E2, BlendMode.srcIn)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: CommonTextFieldWidget(
                                  keyboardType: TextInputType.text,
                                  controller: firstNameController,
                                  hintText: 'First Name',
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: CommonTextFieldWidget(
                                  keyboardType: TextInputType.text,
                                  controller: lastNameController,
                                  hintText: 'Last Name',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          CommonTextWidget.PoppinsRegular(
                            text: 'Email',
                            color: AppColors.black2E2,
                            fontSize: 12,
                          ),
                          SizedBox(height: 5),
                          CommonTextFieldWidget(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            hintText: 'Enter Email',
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: CommonTextWidget.PoppinsRegular(
                              text: 'Contact No',
                              color: AppColors.black2E2,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.grey9B9.withValues(alpha: 0.25),
                                  border: Border.all(color: AppColors.greyE2E, width: 1),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      children: [
                                        CommonTextWidget.PoppinsRegular(
                                          text: '+91.',
                                          color: AppColors.black2E2,
                                          fontSize: 14,
                                        ),
                                        SizedBox(width: 5),
                                        SvgPicture.asset(arrowDownIcon,
                                            colorFilter: ColorFilter.mode(AppColors.black2E2, BlendMode.srcIn)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: CommonTextFieldWidget(
                                  keyboardType: TextInputType.text,
                                  controller: firstNameController,
                                  hintText: '9758******',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Image.asset(hotelReviewBookingImage4, height: 20),
                          SizedBox(height: 10),
                          Divider(color: AppColors.greyE8E, thickness: 1),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              Get.to(() => SelectGuestScreen());
                            },
                            child: CommonTextWidget.PoppinsSemiBold(
                              text: '+ Add Another Guest',
                              color: AppColors.blue1F9,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: RichText(
                    text: TextSpan(
                      text: 'By proceeding. I agree to MakeMyTrip’s ',
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsRegular,
                        fontSize: 12,
                        color: AppColors.grey969,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'User Agrement. Terms of service ',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.PoppinsRegular,
                              color: AppColors.blue1F9),
                        ),
                        TextSpan(
                          text: 'and ',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.PoppinsRegular,
                              color: AppColors.grey969),
                        ),
                        TextSpan(
                          text: 'Cancellation & Property Booking Policies',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontFamily.PoppinsRegular,
                              color: AppColors.blue1F9),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: CommonButtonWidget.button(
                    text: 'CONTINUE',
                    onTap: () {
                      Get.to(() => SelectPaymentMethodScreen());
                    },
                    buttonColor: AppColors.redCA0,
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
}
