import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/presentation/screens/navigation/navigation_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_button_widget.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../shared/constants/font_family.dart';
import '../../../profile/presentation/controllers/full_name_controller.dart';

class FullNameScreen extends StatelessWidget {
  FullNameScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final FullNameController fullNameController = Get.put(FullNameController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, color: AppColors.black2E2, size: 20),
            ),
            SizedBox(height: 30),
            CommonTextWidget.PoppinsSemiBold(
              text: 'Welcome Aboard!',
              color: AppColors.black2E2,
              fontSize: 20,
            ),
            CommonTextWidget.PoppinsRegular(
              text: 'Complete your profile to make your booking faster.',
              color: AppColors.black2E2,
              fontSize: 16,
            ),
            SizedBox(height: 35),
            TextFormField(
              onChanged:(value) {
                if (value.isNotEmpty) {
                  fullNameController.isTextEmpty.value = true;
                } else {
                  fullNameController.isTextEmpty.value = false;
                }
              },
              keyboardType: TextInputType.text,
              cursorColor: AppColors.black2E2,
              controller: nameController,
              style: TextStyle(
                color: AppColors.black2E2,
                fontSize: 14,
                fontFamily: FontFamily.PoppinsRegular,
              ),
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(
                  color: AppColors.grey929,
                  fontSize: 16,
                  fontFamily: FontFamily.PoppinsMedium,
                ),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: EdgeInsets.only(left: 22),
                disabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                focusedBorder:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppColors.redCA0, width: 1.5)),
              ),
            ),
            Spacer(),
            Obx(
                  () => CommonButtonWidget.button(
                onTap: () {
                  Get.to(() => NavigationScreen());
                },
                buttonColor:
                fullNameController.isTextEmpty.isFalse ? AppColors.greyD8D : AppColors.redCA0,
                text: 'SUBMIT',
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
}
