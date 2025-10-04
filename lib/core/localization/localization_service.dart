// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LocalizationService {
//   static Future<Locale> initializeLocale() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String savedLanguage = prefs.getString('selected_language') ?? 'english';

//     if (savedLanguage == 'hebrew') {
//       return Locale('he', 'IL');
//     } else {
//       return Locale('en', 'US');
//     }
//   }

//   static Future<void> changeLanguage(String language) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selected_language', language);

//     if (language == 'hebrew') {
//       Get.updateLocale(Locale('he', 'IL'));
//     } else {
//       Get.updateLocale(Locale('en', 'US'));
//     }
//   }

//   static Future<String> getSavedLanguage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('selected_language') ?? 'english';
//   }
// }
