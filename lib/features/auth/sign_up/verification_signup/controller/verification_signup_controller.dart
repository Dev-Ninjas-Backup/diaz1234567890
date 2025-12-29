import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class VerificationSignupController extends GetxController {
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
      await Future.delayed(Duration(milliseconds: 500));
      EasyLoading.dismiss();
      return;
    }
    isVerifying.value = true;

    isVerifying.value = false;

    if (pin == pinController.text.trim()) {
      Get.offAllNamed('/bottomNavBar');
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
