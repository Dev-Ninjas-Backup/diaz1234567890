import 'package:diaz1234567890/app.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/core/services/socket_manager.dart';
import 'package:diaz1234567890/core/services/stripe_service.dart';
import 'package:diaz1234567890/features/auth/login_screen/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from lib/.env (declared in pubspec assets)
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // If loading fails, continue — StripeService will also attempt to load.
  }

  await StorageService.init();

  // Initialize Stripe for payments
  await StripeService.initialize();

  Get.put(LoginController());
  Get.put(SocketManager());

  // Sync the reactive guest/auth state from persisted storage so Obx widgets
  // that observe `isGuest` will build consistently on startup.
  try {
    final lc = Get.find<LoginController>();
    lc.isGuest.value = !StorageService.hasToken();
  } catch (_) {
    // If the controller isn't available for some reason, ignore.
  }

  runApp(Diaz());
}