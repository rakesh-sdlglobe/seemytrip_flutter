import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/common_text_widget.dart';
import '../../../../../core/widgets/lists_widget.dart';

class MyWishListScreen extends StatelessWidget {
  MyWishListScreen({Key? key}) : super(key: key);

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
          text: 'My Wishlist',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 20),
          shrinkWrap: true,
          itemCount: Lists.wishListList.length,
          itemBuilder: (context, index) => Image.asset(
              Lists.wishListList[index],
              width: 327,
            )),
    );
}
