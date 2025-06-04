import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart'; // Replace with your own color constants
import 'package:get/get.dart';
import '../Controller/otp_controller.dart';

class OtpScreen2 extends StatefulWidget {
  @override
  _OtpScreen2State createState() => _OtpScreen2State();
}

class _OtpScreen2State extends State<OtpScreen2> {
  final int _otpLength = 6;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final _emailController = TextEditingController();
  final OtpController controller = Get.put(OtpController());

  @override
  void initState() {
    super.initState();
    // Initialize controllers and focus nodes with correct length
    _controllers = List.generate(_otpLength, (index) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (index) => FocusNode());
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _emailController.dispose();
    super.dispose();
  }

  Widget _buildInitialInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email Verification",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Enter your email address to receive the verification code.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 25),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email Address",
            labelStyle: TextStyle(color: Colors.black54),
            hintText: "Enter your email",
            hintStyle: TextStyle(color: Colors.black38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: redCA0, width: 2),
            ),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: controller.isLoading.value 
            ? null 
            : () async {
                String email = _emailController.text.trim();
                if (email.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please enter your email address.',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Show loading state
                controller.isLoading.value = true;
                
                try {
                  final success = await controller.sendOtp(email);
                  if (success) {
                    // OTP sent successfully, UI will update via Obx
                    print('OTP sent successfully to $email');
                  }
                } catch (e) {
                  print('Error sending OTP: $e');
                }
              },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: controller.isLoading.value ? Colors.grey : redCA0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
          ),
          child: controller.isLoading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Send Verification Code",
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ],
    );
  }

  Widget _buildOtpVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: redCA0.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, color: redCA0, size: 18),
              SizedBox(width: 5),
              Text(
                "${(controller.secondsRemaining.value ~/ 60).toString().padLeft(2, '0')}:${(controller.secondsRemaining.value % 60).toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 15,
                  color: redCA0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Enter the verification code sent to ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: _emailController.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: redCA0,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_otpLength, (index) => _buildOtpField(index)),
        ),
        SizedBox(height: 30),
        Obx(() => ElevatedButton(
          onPressed: controller.isButtonEnabled.value 
              ? () => controller.verifyOtp(_controllers.map((e) => e.text).join())
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: controller.isButtonEnabled.value ? redCA0 : Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: controller.isButtonEnabled.value ? 2 : 0,
          ),
          child: Text(
            "Verify Email",
            style: TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildOtpField(int index) {
    return Container(
      width: 45,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < _otpLength - 1) {
            // Move to next field
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            // Move to previous field
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }

          // Check if all fields are filled
          if (_controllers.every((controller) => controller.text.isNotEmpty)) {
            String otp = _controllers.map((e) => e.text).join();
            controller.updateButtonState(otp);
          } else {
            controller.updateButtonState('');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyE2E,
      appBar: AppBar(
        title: Text("Email Verification", style: TextStyle(color: white)),
        backgroundColor: redCA0,
        iconTheme: IconThemeData(color: white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            heightFactor: 1.4,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!controller.showOtpFields.value) 
                    _buildInitialInputSection()
                  else 
                    _buildOtpVerificationSection(),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
