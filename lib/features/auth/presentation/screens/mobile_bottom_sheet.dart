import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/features/auth/presentation/controllers/mobile_otp_controller.dart';

class MobileOtpBottomSheet extends StatelessWidget {
  final MobileOtpController otpController = Get.put(MobileOtpController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 0,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login with Mobile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: redCA0,
                    ),
              ),
              SizedBox(height: 20),
              Text(
                'Enter Mobile Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: otpController.mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(height: 20),
              Obx(() => otpController.isOtpSent.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter OTP',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: otpController.otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'OTP',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => otpController.verifyOtp(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: redCA0,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Verify OTP',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () => otpController.sendOtp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redCA0,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Send OTP',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
