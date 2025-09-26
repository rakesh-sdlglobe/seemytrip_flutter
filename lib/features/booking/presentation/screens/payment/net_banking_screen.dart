import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';
import '../../../../../main.dart';
import '../../../../../shared/constants/font_family.dart';
import '../../../../../shared/constants/images.dart';
import '../../../../shared/presentation/controllers/net_banking_controller.dart';
import 'fare_breakUp_screen.dart';

class NetBankingScreen extends StatelessWidget {
  NetBankingScreen({Key? key}) : super(key: key);

  final NetBankingController netBankingController =
      Get.put(NetBankingController());

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
            text: 'Net Banking',
            color: AppColors.white,
            fontSize: 18,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 22),
              child: Icon(CupertinoIcons.search, color: AppColors.white),
            ),
          ],
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
                    GetBuilder<NetBankingController>(
                      init: NetBankingController(),
                      builder: (controller) => ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Lists.netBankingList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              leading: Image.asset(
                                  Lists.netBankingList[index]['image'],
                                  height: 30,
                                  width: 30),
                              title: CommonTextWidget.PoppinsMedium(
                                text: Lists.netBankingList[index]['text'],
                                color: AppColors.black2E2,
                                fontSize: 15,
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  controller.onIndexChange(index);
                                  netBankingController.isClick.value = true;
                                },
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  decoration: BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color:
                                              controller.selectedIndex == index
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
            Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: Get.width,
                  color: AppColors.black2E2,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, right: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                          fontFamily: FontFamily.PoppinsMedium,
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
                          // SizedBox(width: 17.75),
                          Obx(() => netBankingController.isClick.value == true
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
                                      minWidth: 130,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      color: AppColors.redCA0,
                                      child: CommonTextWidget.PoppinsSemiBold(
                                        fontSize: 14,
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
                                )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
