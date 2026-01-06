import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';

class ProfileController extends GetxController {
  final privacyToggle = false.obs;
  final notificationToggle = true.obs;

  // user info
  final userName = RxnString();
  final avatarUrl = RxnString();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      // Ensure SharedPreferences (StorageService) is initialized before
      // reading the token. This avoids a null token when init hasn't run yet.
      if (!StorageService.isInitialized) {
        if (kDebugMode) print('StorageService not initialized; calling init()');
        await StorageService.init();
      }

      final token = StorageService.token;
      if (kDebugMode) {
        print(
          'Profile fetch: token present=${token != null && token.isNotEmpty}',
        );
      }

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.userMe);
      if (kDebugMode) print('Profile fetch: GET $uri');
      final resp = await http.get(uri, headers: headers);
      if (kDebugMode) print('Profile fetch status: ${resp.statusCode}');

      // Log body for debugging (only in debug builds)
      if (kDebugMode) {
        try {
          print('Profile fetch body: ${resp.body}');
        } catch (_) {}
      }

      if (resp.statusCode == 200) {
        final jsonBody = json.decode(resp.body);

        // Support multiple possible response shapes:
        // 1) { success: true, data: { name:..., avatarUrl:... } }
        // 2) { success: true, data: { user: { ... } } }
        // 3) { user: { ... } }
        Map<String, dynamic>? data;

        if (jsonBody['success'] == true && jsonBody['data'] is Map) {
          final d = jsonBody['data'] as Map<String, dynamic>;
          if (d['user'] is Map) {
            data = d['user'] as Map<String, dynamic>;
          } else {
            data = d;
          }
        } else if (jsonBody['user'] is Map) {
          data = jsonBody['user'] as Map<String, dynamic>;
        } else if (jsonBody is Map &&
            jsonBody['data'] == null &&
            jsonBody['name'] != null) {
          // sometimes API returns the user object directly
          data = Map<String, dynamic>.from(jsonBody);
        }

        if (data != null) {
          userName.value =
              (data['username'])
                  ?.toString() ??
              '';
          avatarUrl.value =
              (data['avatarUrl'])
                  ?.toString();
          if (kDebugMode) {
            print(
              'Profile parsed: name=${userName.value}, avatar=${avatarUrl.value}',
            );
          }
        } else {
          if (kDebugMode) print('Profile fetch: unexpected JSON shape');
        }
      } else {
        if (kDebugMode) print('Profile fetch failed: HTTP ${resp.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void togglePrivacy() => privacyToggle.value = !privacyToggle.value;
  void toggleNotification() =>
      notificationToggle.value = !notificationToggle.value;
}
