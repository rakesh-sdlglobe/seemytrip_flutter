import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:seemytrip/core/theme/app_colors.dart';
import '../../../../core/utils/common_textfeild_widget.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../shared/constants/images.dart';

class SelectGuestScreen extends StatelessWidget {
  SelectGuestScreen({Key? key}) : super(key: key);
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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
            child: Icon(Icons.cancel, color: AppColors.white, size: 20),
          ),
          title: CommonTextWidget.PoppinsSemiBold(
            text: 'Select Guests',
            color: AppColors.white,
            fontSize: 18,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              CommonTextWidget.PoppinsSemiBold(
                text: 'Add new Guest',
                color: AppColors.black2E2,
                fontSize: 16,
              ),
              CommonTextWidget.PoppinsRegular(
                text:
                    'Name should be per official govt. ID & travelers below 18 '
                    'years od age cannot travel alone.',
                color: AppColors.black2E2,
                fontSize: 12,
              ),
              SizedBox(height: 15),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey515.withOpacity(0.25),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextWidget.PoppinsRegular(
                        text: 'NAME AS PER PASSPORT',
                        color: AppColors.grey717,
                        fontSize: 14,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.grey9B9.withOpacity(0.25),
                              border: Border.all(color: AppColors.greyE2E, width: 1),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    CommonTextWidget.PoppinsRegular(
                                      text: 'Mr.',
                                      color: AppColors.black2E2,
                                      fontSize: 14,
                                    ),
                                    SizedBox(width: 5),
                                    SvgPicture.asset(arrowDownIcon,
                                        color: AppColors.black2E2),
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
                      SizedBox(height: 20),
                      Image.asset(selectGuestImage, height: 20),
                    ],
                  ),
                ),
              ),
              Spacer(),
              CommonButtonWidget.button(
                text: 'DONE',
                onTap: () {},
                buttonColor: AppColors.redCA0,
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      );
}
