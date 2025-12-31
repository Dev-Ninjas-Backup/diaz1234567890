import 'package:diaz1234567890/app.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/features/auth/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  Get.put(LoginController());
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(Diaz());
}
