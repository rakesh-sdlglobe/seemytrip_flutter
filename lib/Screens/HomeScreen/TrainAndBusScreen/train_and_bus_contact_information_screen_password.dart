import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Controller/irctc_forgot_details_controller.dart';
import 'package:seemytrip/Controller/train_contact_information_controller.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class ForgotIRCTCPasswordScreen extends StatefulWidget {
  final String? username;

  const ForgotIRCTCPasswordScreen({Key? key, this.username}) : super(key: key);

  @override
  _ForgotIRCTCPasswordScreenState createState() => _ForgotIRCTCPasswordScreenState();
}

class _ForgotIRCTCPasswordScreenState extends State<ForgotIRCTCPasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final IRCTCForgotDetailsController controller = Get.put(IRCTCForgotDetailsController());
  late final TrainContactInformationController trainController;

  @override
  void initState() {
    super.initState();
    try {
      trainController = Get.find<TrainContactInformationController>();
      // First check widget username
      if (widget.username != null && widget.username!.isNotEmpty) {
        _usernameController.text = widget.username!;
        controller.validateUsername(widget.username!);
      }
      // Then check controller username if widget username is not available
      else if (trainController.username.value.isNotEmpty) {
        _usernameController.text = trainController.username.value;
        controller.validateUsername(trainController.username.value);
      }
    } catch (e) {
      trainController = Get.put(TrainContactInformationController());
      // Check widget username even if controller initialization fails
      if (widget.username != null && widget.username!.isNotEmpty) {
        _usernameController.text = widget.username!;
        controller.validateUsername(widget.username!);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _mobileController.dispose();
    controller.clearForm();
    super.dispose();
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
            _buildHeader(),
            SizedBox(height: 15),
            _buildInfoBox(),
            SizedBox(height: 20),
            _buildUsernameField(),
            SizedBox(height: 15),
            _buildMobileField(),
            _buildMessageBox(),
            SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
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
          'Forgot IRCTC Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: yellowF7C.withOpacity(0.3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CommonTextWidget.PoppinsMedium(
        text: "Please enter your registered IRCTC Username and mobile number to recover your IRCTC Password",
        color: yellowCE8,
        fontSize: 12,
      ),
    );
  }

  Widget _buildUsernameField() {
    return Container(
      decoration: BoxDecoration(
        color: greyE2E,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: CommonTextWidget.PoppinsMedium(
          text: "IRCTC USERNAME",
          color: grey888,
          fontSize: 12,
        ),
        subtitle: TextField(
          controller: _usernameController,
          // enabled: false, // Disable editing since username is pre-filled
          decoration: InputDecoration(
            hintText: widget.username ?? trainController.username.value,
            hintStyle: TextStyle(color: grey888, fontSize: 12),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileField() {
    return Container(
      decoration: BoxDecoration(
        color: greyE2E,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: CommonTextWidget.PoppinsMedium(
          text: "MOBILE NUMBER",
          color: grey888,
          fontSize: 12,
        ),
        subtitle: TextField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          onChanged: (value) => controller.validateMobile(value),
          decoration: InputDecoration(
            hintText: "Enter registered mobile number",
            hintStyle: TextStyle(color: grey888, fontSize: 12),
            border: InputBorder.none,
            counterText: "",
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBox() {
    return Obx(() {
      if (controller.errorMessage.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        );
      }
      if (controller.successMessage.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            controller.successMessage.value,
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _buildSubmitButton() {
    return Obx(() => MaterialButton(
          height: 50,
          minWidth: Get.width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: redCA0,
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  if (_usernameController.text.isEmpty ||
                      _mobileController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill all required fields',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final success = await controller.getForgotDetails();

                  if (success) {
                    Get.back();
                    Get.snackbar(
                      'Success',
                      'Password reset instructions sent to your mobile number',
                      backgroundColor: Colors.green,
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
        ));
  }
}
