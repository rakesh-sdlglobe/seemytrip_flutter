import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/utils/common_textfeild_widget.dart';
import '../../../../../../core/widgets/common_button_widget.dart';
import '../../../../../../core/widgets/common_text_widget.dart';
import '../../../../../../shared/constants/images.dart';
import '../ScanScreen/scan_screen.dart';

class AddTravellerScreen extends StatelessWidget {
  AddTravellerScreen({Key? key}) : super(key: key);
  final TextEditingController firstAndMiddleNameController =
      TextEditingController();
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
          child: Icon(Icons.close, color: AppColors.white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: 'Add Traveller',
          color: AppColors.white,
          fontSize: 18,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Get.width,
            color: AppColors.orangeEB9.withValues(alpha: 0.2),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: CommonTextWidget.PoppinsRegular(
                text: 'Enter name as mentioned on your passport for '
                    'Goverment approved IDs.',
                color: AppColors.black2E2,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppColors.greyE2E, width: 1),
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset(scan),
                      title: CommonTextWidget.PoppinsMedium(
                        text: 'Scan to auto-fill this form!',
                        color: AppColors.black2E2,
                        fontSize: 13,
                      ),
                      subtitle: CommonTextWidget.PoppinsRegular(
                        text: 'Fetch details from your passport',
                        color: AppColors.grey717,
                        fontSize: 13,
                      ),
                      trailing: InkWell(
                        onTap: (){
                          Get.bottomSheet(
                            ScanScreen(),
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                          );
                        },
                        child: CommonTextWidget.PoppinsMedium(
                          text: 'SCAN',
                          color: AppColors.redCA0,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  CommonTextWidget.PoppinsMedium(
                    text: 'GENDER',
                    color: AppColors.grey717,
                    fontSize: 14,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.greyE2E, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: 'MALE',
                              color: AppColors.redCA0,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.greyE2E, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: CommonTextWidget.PoppinsMedium(
                              text: 'FEMALE',
                              color: AppColors.redCA0,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  CommonTextFieldWidget(
                    hintText: 'First & Middle Name',
                    controller: firstAndMiddleNameController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  CommonTextFieldWidget(
                    hintText: 'Last Name',
                    controller: lastNameController,
                    keyboardType: TextInputType.text,
                  ),
                  Spacer(),
                  CommonButtonWidget.button(
                    text: 'CONFIRM',
                    buttonColor: AppColors.redCA0,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}
