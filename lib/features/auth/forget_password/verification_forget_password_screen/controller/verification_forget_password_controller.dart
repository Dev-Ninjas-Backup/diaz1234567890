import 'package:diaz1234567890/features/auth/forget_password/Reset_password/screen/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class VerificationForgetPasswordController extends GetxController {
  final pinController = TextEditingController();
  final isVerifying = false.obs;
  final errorMessage = RxnString();

  void onCompleted(String value) {
    //if added any validation
  }

  void verifyOtp() async {
    final pin = pinController.text.trim();
    if (pin.length < 4) {
      EasyLoading.showError("Please enter 4 digits code");
      await Future.delayed(const Duration(milliseconds: 500));
      EasyLoading.dismiss();
      return;
    }
    isVerifying.value = true;

    isVerifying.value = false;

    if (pin == pinController.text.trim()) {
      Get.to(ResetPasswordPage());
      pinController.clear();
    } else {
      errorMessage.value = "Invalid OTP";
      EasyLoading.showError(errorMessage.value.toString());
      pinController.clear();
    }
  }

  @override
  void onClose() {
    pinController.dispose();
    super.onClose();
  }
}
