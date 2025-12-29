import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  var resetPasswordController = TextEditingController();
  var resetConfirmPasswordController = TextEditingController();





  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void toggleVisibleObsecurePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleVisibleObsecureConfirmPassword() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }




}
