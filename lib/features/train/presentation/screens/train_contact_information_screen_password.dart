import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seemytrip/features/shared/presentation/controllers/irctc_forgot_details_controller.dart';
import 'package:seemytrip/features/train/presentation/controllers/train_contact_information_controller.dart';
import 'package:seemytrip/core/theme/app_colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

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
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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

  Widget _buildHeader() => Column(
      children: <Widget>[
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Text(
          'Forgot IRCTC Password',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            color: Theme.of(context).textTheme.headlineSmall?.color,
          ),
        ),
      ],
    );

  Widget _buildInfoBox() => Container(
      width: Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Theme.of(context).brightness == Brightness.dark 
          ? const Color(0xFF3E2723).withOpacity(0.9)
          : AppColors.yellowF7C.withValues(alpha: 0.3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CommonTextWidget.PoppinsMedium(
        text: 'Please enter your registered IRCTC Username and mobile number to recover your IRCTC Password',
        color: Theme.of(context).brightness == Brightness.dark 
          ? const Color(0xFFBCAAA4)
          : AppColors.yellowCE8,
        fontSize: 12,
      ),
    );

  Widget _buildUsernameField() => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey[800]
          : AppColors.greyE2E,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: CommonTextWidget.PoppinsMedium(
          text: 'IRCTC USERNAME',
          color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey888,
          fontSize: 12,
        ),
        subtitle: TextField(
          controller: _usernameController,
          // enabled: false, // Disable editing since username is pre-filled
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          decoration: InputDecoration(
            hintText: widget.username ?? trainController.username.value,
            hintStyle: TextStyle(
              color: Theme.of(context).hintColor, 
              fontSize: 12
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );

  Widget _buildMobileField() => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey[800]
          : AppColors.greyE2E,
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        title: CommonTextWidget.PoppinsMedium(
          text: 'MOBILE NUMBER',
          color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey888,
          fontSize: 12,
        ),
        subtitle: TextField(
          controller: _mobileController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          onChanged: (String value) => controller.validateMobile(value),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          decoration: InputDecoration(
            hintText: 'Enter registered mobile number',
            hintStyle: TextStyle(
              color: Theme.of(context).hintColor, 
              fontSize: 12
            ),
            border: InputBorder.none,
            counterText: '',
          ),
        ),
      ),
    );

  Widget _buildMessageBox() => Obx(() {
      if (controller.errorMessage.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error, 
              fontSize: 12
            ),
          ),
        );
      }
      if (controller.successMessage.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            controller.successMessage.value,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.green[400]
                : AppColors.green00A,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });

  Widget _buildSubmitButton() => Obx(() => MaterialButton(
          height: 50,
          minWidth: Get.width,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          color: AppColors.redCA0,
          onPressed: controller.isLoading.value
              ? null
              : () async {
                  if (_usernameController.text.isEmpty ||
                      _mobileController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please fill all required fields',
                      backgroundColor: AppColors.redCA0,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final bool success = await controller.getForgotDetails();

                  if (success) {
                    Get..back()
                    ..snackbar(
                      'Success',
                      'Password reset instructions sent to your mobile number',
                      backgroundColor: AppColors.green00A,
                      colorText: AppColors.white,
                    );
                  }
                },
          child: controller.isLoading.value
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: AppColors.white,
                    size: 20,
                  ),
                )
              : CommonTextWidget.PoppinsSemiBold(
                  fontSize: 16,
                  text: 'SUBMIT',
                  color: AppColors.white,
                ),
        ));
}
