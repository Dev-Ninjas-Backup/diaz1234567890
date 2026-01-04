import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      if (kDebugMode) {
        print('Validation Failed: Empty fields');
      }
      Get.snackbar(
        "Error",
        "Please fill all fields",
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (StorageService.preferences == null) {
      await StorageService.init();
      if (kDebugMode) {
        print('SharedPreferences initialized in LoginController');
      }
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    if (kDebugMode) {
      print('Loading dialog shown');
    }

    final requestBody = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(Endpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
      }

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          final userData = jsonResponse['data']['user'];
          final String userId = userData['id'];
          final String token = jsonResponse['data']['token'];
          await StorageService.saveToken(token, userId);
          isGuest.value = false;
          print("User Token: $token");

          Get.offAllNamed('/bottomNavBar');
        } else {
          final message = jsonResponse['message'] ?? "Login failed";
          Get.snackbar(
            "Error",
            message,
            // ignore: deprecated_member_use
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        // Non-201 status code
        String message = "Login failed";
        try {
          final errorBody = jsonDecode(response.body);
          message = errorBody['message'] ?? message;
        } catch (_) {
          if (kDebugMode) {
            print('Could not parse error response body (possibly not JSON)');
          }
        }
        Get.snackbar(
          "Error",
          message,
          // ignore: deprecated_member_use
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
        if (kDebugMode) {
          print('Loading dialog dismissed due to exception');
        }
      }

      Get.snackbar(
        "Error",
        "Network error. Please check your connection.",
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void loginAsGuest() {
    isGuest.value = true;
    Get.offAllNamed('/bottomNavBar');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
