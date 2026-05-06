import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  var rememberMe = false.obs;
  var isPasswordHidden = true.obs;

  var isGuest = true.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Print existing token if available
    _printExistingToken();
  }

  Future<void> _printExistingToken() async {
    // Ensure StorageService is initialized
    if (!StorageService.isInitialized) {
      await StorageService.init();
    }

    final existingToken = StorageService.token;
    final userId = StorageService.userId;

    if (existingToken != null && existingToken.isNotEmpty) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════');
        print('Existing User Token Found');
        print('Token: $existingToken');
        print('User ID: $userId');
        print('═══════════════════════════════════════════════════════');
      }
      isGuest.value = false;
    } else {
      if (kDebugMode) {
        print('No existing token found - User is guest');
      }
    }
  }

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
      EasyLoading.showError('Please fill all fields');
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
          if (kDebugMode) {
            print('═══════════════════════════════════════════════════════');
            print('Login Successful!');
            print('Token: $token');
            print('User ID: $userId');
            print('═══════════════════════════════════════════════════════');
          }

          Get.offAllNamed('/bottomNavBar');
        } else {
          final message = jsonResponse['message'] ?? "Login failed";
          EasyLoading.showError(message.toString());
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
        EasyLoading.showError(message.toString());
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
        if (kDebugMode) {
          print('Loading dialog dismissed due to exception');
        }
      }

      EasyLoading.showError('Network error. Please check your connection.');
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
