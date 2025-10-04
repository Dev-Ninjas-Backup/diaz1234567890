// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  static Map<String, Map<String, String>>? _keys;
  @override
  Map<String, Map<String, String>> get keys => throw UnimplementedError();
  static Future<void> loadTranslations() async {
    try {
      // Load English translations
      final enString = await rootBundle.loadString('assets/locales/en.json');
      final Map<String, dynamic> enJson = json.decode(enString);
      final Map<String, String> enTranslations = enJson.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      // Load Hebrew translations
      final heString = await rootBundle.loadString('assets/locales/he.json');
      final Map<String, dynamic> heJson = json.decode(heString);
      final Map<String, String> heTranslations = heJson.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      _keys = {'en_US': enTranslations, 'he_IL': heTranslations};
    } catch (e) {
      // Fallback translations if JSON loading fails
      _keys = {
        'en_US': {
          'general_setting': 'General Setting',
          'apps_language': "App's Language",
          'english': 'English',
        },
      };
    }
  }
}
