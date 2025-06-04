import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/font_family.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Controller/mobile_wallet_controller.dart';
import 'package:seemytrip/Controller/net_banking_controller.dart';
import 'package:seemytrip/Screens/SelectPaymentMethodScreen/fare_breakUp_screen.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';
import 'package:seemytrip/main.dart';

class MobileWalletScreen extends StatelessWidget {
  MobileWalletScreen({Key? key}) : super(key: key);

  final MobileWalletController mobileWalletController =
      Get.put(MobileWalletController());

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
          text: "Mobile Wallet",
          color: white,
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
                    color: redF9E.withOpacity(0.75),
                    child: ListTile(
                      title: CommonTextWidget.PoppinsSemiBold(
                        text: "Select Provider",
                        color: black2E2,
                        fontSize: 15,
                      ),
                      subtitle: CommonTextWidget.PoppinsRegular(
                        text: "for payment via net banking options",
                        color: grey717,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  GetBuilder<NetBankingController>(
                    init: NetBankingController(),
                    builder: (controller) => ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Lists.mobileWalletList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            leading: Image.asset(
                                Lists.mobileWalletList[index]["image"],
                                height: 30,
                                width: 30),
                            title: CommonTextWidget.PoppinsMedium(
                              text: Lists.mobileWalletList[index]["text"],
                              color: black2E2,
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
                                            color: redCA0,
                                            shape: BoxShape.circle),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                          Divider(color: greyE8E, thickness: 1),
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
                      color: black2E2,
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
                                    text: "₹ 5,950 ",
                                    style: TextStyle(
                                      fontFamily: FontFamily.PoppinsSemiBold,
                                      fontSize: 16,
                                      color: white,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Due now ",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontFamily:
                                                FontFamily.PoppinsMedium,
                                            color: grey8E8),
                                      ),
                                    ],
                                  ),
                                ),
                                CommonTextWidget.PoppinsMedium(
                                  text: "Convenience Fee added",
                                  color: grey8E8,
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
                                        color: redCA0,
                                        child: CommonTextWidget.PoppinsSemiBold(
                                          fontSize: 16,
                                          text: "CONTINUE",
                                          color: white,
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
}
