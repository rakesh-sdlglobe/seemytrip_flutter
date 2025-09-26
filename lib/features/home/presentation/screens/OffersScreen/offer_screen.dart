import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/features/home/presentation/controllers/offer_controller.dart';
import 'package:seemytrip/features/home/presentation/screens/OffersScreen/offer_detail_screen.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart';
import 'package:seemytrip/main.dart';

class OfferScreen extends StatelessWidget {
  OfferScreen({Key? key}) : super(key: key);

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
          text: 'Offers',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 70,
                width: Get.width,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: GetBuilder<OfferController>(
                    init: OfferController(),
                    builder: (controller) => ListView.builder(
                      itemCount: Lists.offerList1.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(
                          top: 13, bottom: 13, left: 24, right: 12),
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            controller.onIndexChange(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: controller.selectedIndex == index
                                  ? AppColors.redCA0.withValues(alpha: 0.12)
                                  : AppColors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.grey515.withOpacity(0.25),
                                  blurRadius: 6,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: CommonTextWidget.PoppinsMedium(
                                  text: Lists.offerList1[index],
                                  color: controller.selectedIndex == index
                                      ? AppColors.redCA0.withValues(alpha: 1)
                                      : AppColors.black2E2,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                shrinkWrap: true,
                itemCount: Lists.offerList2.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => OfferDetailScreen());
                    },
                    child: Image.asset(
                      Lists.offerList2[index],
                      height: 186,
                      width: Get.width,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
