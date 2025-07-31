import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Controller/irctc_forgot_details_controller.dart';

class ForgotIRCTCUsernameScreen extends StatefulWidget {
  @override
  _ForgotIRCTCUsernameScreenState createState() => _ForgotIRCTCUsernameScreenState();
}

class _ForgotIRCTCUsernameScreenState extends State<ForgotIRCTCUsernameScreen> {
  final IRCTCForgotDetailsController controller = Get.put(IRCTCForgotDetailsController());
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    _contactController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('en', 'US'), // Specify locale explicitly
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
        controller.dob.value = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Forgot IRCTC Username',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 15),
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: yellowF7C.withOpacity(0.3),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: CommonTextWidget.PoppinsMedium(
                text:
                    "Please enter your registered email ID or mobile number and date of birth to recover your IRCTC username",
                color: yellowCE8,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            _inputField(
              "EMAIL/MOBILE",
              _contactController,
              "Enter registered email ID or mobile number",
              TextInputType.emailAddress,
              onChanged: (value) {
                if (value.contains('@')) {
                  controller.validateEmail(value);
                } else {
                  controller.validateMobile(value);
                }
              },
            ),
            Obx(() => controller.errorMessage.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : SizedBox.shrink()),
            SizedBox(height: 15),
            _dobField("DATE OF BIRTH", _dobController),
            SizedBox(height: 30),
            Obx(() => MaterialButton(
                  height: 50,
                  minWidth: Get.width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: redCA0,
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (_contactController.text.isEmpty ||
                              _dobController.text.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please fill all required fields.',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          final success = await controller.submitForm();

                          if (success) {
                            Get.back();
                            Get.snackbar(
                              'Success',
                              controller.successMessage.value,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              controller.errorMessage.value,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: white,
                            strokeWidth: 2,
                          ),
                        )
                      : CommonTextWidget.PoppinsSemiBold(
                          fontSize: 16,
                          text: "SUBMIT",
                          color: white,
                        ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, String hint,
      TextInputType inputType, {int? maxLength, Function(String)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: greyE2E,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: CommonTextWidget.PoppinsMedium(
          text: label,
          color: grey888,
          fontSize: 12,
        ),
        subtitle: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLength: maxLength,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: grey888, fontSize: 12),
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }

  Widget _dobField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: greyE2E,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: CommonTextWidget.PoppinsMedium(
          text: label,
          color: grey888,
          fontSize: 12,
        ),
        subtitle: TextField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: "Select date of birth",
            hintStyle: TextStyle(color: grey888, fontSize: 12),
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }
}
