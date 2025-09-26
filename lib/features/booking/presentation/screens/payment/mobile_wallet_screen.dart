import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../profile/presentation/controllers/mobile_wallet_controller.dart';
import 'fare_breakUp_screen.dart';

class MobileWalletScreen extends StatelessWidget {
  MobileWalletScreen({Key? key}) : super(key: key);

  final MobileWalletController mobileWalletController =
      Get.put(MobileWalletController());

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
          text: 'Mobile Wallet',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: Get.width,
                    color: AppColors.redF9E.withOpacity(0.75),
                    child: ListTile(
                      title: CommonTextWidget.PoppinsSemiBold(
                        text: 'Select Provider',
                        color: AppColors.black2E2,
                        fontSize: 15,
                      ),
                      subtitle: CommonTextWidget.PoppinsRegular(
                        text: 'for payment via net banking options',
                        color: AppColors.grey717,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  GetBuilder<MobileWalletController>(
                    init: MobileWalletController(),
                    builder: (controller) => ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Lists.mobileWalletList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                                Lists.mobileWalletList[index]['image'],
                                height: 30,
                                width: 30),
                            title: CommonTextWidget.PoppinsMedium(
                              text: Lists.mobileWalletList[index]['text'],
                              color: AppColors.black2E2,
                              fontSize: 15,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                controller.onIndexChange(index);
                                mobileWalletController.isClick.value = true;
                              },
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: controller.selectedIndex == index
                                            ? AppColors.redCA0
                                            : AppColors.grey717)),
                                alignment: Alignment.center,
                                child: controller.selectedIndex == index
                                    ? Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                            color: AppColors.redCA0,
                                            shape: BoxShape.circle),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                          Divider(color: AppColors.greyE8E, thickness: 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 55),
                      child: Image.asset(paymentMethodBottomImage),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 65,
                      width: Get.width,
                      color: AppColors.black2E2,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: '₹ 5,950 ',
                                    style: TextStyle(
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      fontSize: 16,
                                      color: AppColors.white,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Due now ',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                FontFamily.PoppinsMedium,
                                            color: AppColors.grey8E8),
                                      ),
                                    ],
                                  ),
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: 'Convenience Fee added',
                                  color: AppColors.grey8E8,
                                  fontSize: 10,
                                ),
                              ],
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     Get.bottomSheet(
                            //       FareBreakUpScreen(),
                            //       backgroundColor: Colors.transparent,
                            //       isScrollControlled: true,
                            //     );
                            //   },
                            //   child: SvgPicture.asset(info),
                            // ),
                            mobileWalletController.isClick.value == true
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.bottomSheet(
                                            FareBreakUpScreen(),
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                          );
                                        },
                                        child: SvgPicture.asset(info),
                                      ),
                                      SizedBox(width: 20),
                                      MaterialButton(
                                        onPressed: () {
                                          // Get.to(() => SelectPaymentMethodScreen());
                                        },
                                        height: 40,
                                        minWidth: 140,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        color: AppColors.redCA0,
                                        child: CommonTextWidget.PoppinsSemiBold(
                                          fontSize: 16,
                                          text: 'CONTINUE',
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      Get.bottomSheet(
                                        FareBreakUpScreen(),
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                      );
                                    },
                                    child: SvgPicture.asset(info),
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
        ],
      ),
    );
}
