import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var rememberMe = false.obs;
  var isPasswordHidden = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  get inputFieldColor => null;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    if (emailController.text == "1" && passwordController.text == "1") {
      Get.offAllNamed('/bottomNavBar');
      return;
    }
  }

  void forgotPassword() {}

  void goToSignUp() {}
}
