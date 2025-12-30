import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var rememberMe = false.obs;
  var isPasswordHidden = true.obs;

  var isGuest = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (emailController.text == "1" && passwordController.text == "1") {
      isGuest.value = false;
      Get.offAllNamed('/bottomNavBar');
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
  }

  void loginAsGuest() {
    isGuest.value = true;
    Get.offAllNamed('/bottomNavBar');
  }
}
