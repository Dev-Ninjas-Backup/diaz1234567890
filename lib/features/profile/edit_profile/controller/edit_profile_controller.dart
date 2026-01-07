import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';

class EditProfileController extends GetxController {
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final existingAvatarUrl = RxnString();
  final isLoading = false.obs;

  // Text controllers for editable fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  // Password fields for change password
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      if (!StorageService.isInitialized) {
        if (kDebugMode) print('EditProfile: initializing StorageService');
        await StorageService.init();
      }

      final token = StorageService.token;
      if (kDebugMode)
        print(
          'EditProfile: token present=${token != null && token.isNotEmpty}',
        );

      final headers = {'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty)
        headers['Authorization'] = 'Bearer $token';

      final uri = Uri.parse(Endpoints.userMe);
      if (kDebugMode) print('EditProfile: GET $uri');
      final resp = await http.get(uri, headers: headers);
      if (kDebugMode) print('EditProfile: status ${resp.statusCode}');
      if (kDebugMode) print('EditProfile: body ${resp.body}');

      if (resp.statusCode == 200) {
        final jb = json.decode(resp.body);
        Map<String, dynamic>? data;
        if (jb['success'] == true && jb['data'] is Map) {
          data = jb['data'] as Map<String, dynamic>;
        } else if (jb['user'] is Map) {
          data = jb['user'] as Map<String, dynamic>;
        } else if (jb is Map && jb['data'] == null && jb['name'] != null) {
          data = Map<String, dynamic>.from(jb);
        }

        if (data != null) {
          nameController.text = (data['name'] ?? '')?.toString() ?? '';
          phoneController.text = (data['phone'] ?? '')?.toString() ?? '';
          contactController.text = phoneController.text;
          countryController.text = (data['country'] ?? '')?.toString() ?? '';
          cityController.text = (data['city'] ?? '')?.toString() ?? '';
          stateController.text = (data['state'] ?? '')?.toString() ?? '';
          zipController.text =
              (data['zip'] ?? data['zipCode'] ?? '')?.toString() ?? '';
          existingAvatarUrl.value =
              (data['avatarUrl'] ?? data['avatar'] ?? data['image'])
                  ?.toString();
        } else {
          if (kDebugMode) print('EditProfile: unexpected JSON shape');
        }
      } else {
        if (kDebugMode)
          print('EditProfile: GET failed status ${resp.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('EditProfile: error fetching profile: $e');
      Get.snackbar('Error', 'Failed to load profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveChanges() async {
    isLoading.value = true;
    try {
      if (!StorageService.isInitialized) await StorageService.init();
      final token = StorageService.token;
      // If password change requested, do it first
      final oldPass = oldPasswordController.text.trim();
      final newPass = newPasswordController.text.trim();
      final confirmPass = confirmPasswordController.text.trim();
      if (oldPass.isNotEmpty || newPass.isNotEmpty || confirmPass.isNotEmpty) {
        if (oldPass.isEmpty || newPass.isEmpty) {
          Get.snackbar('Error', 'Please provide current and new password');
          return false;
        }
        if (newPass != confirmPass) {
          Get.snackbar(
            'Error',
            'New password and confirm password do not match',
          );
          return false;
        }
        final pwOk = await changePassword(oldPass, newPass);
        if (!pwOk) return false;
      }

      final uri = Uri.parse(Endpoints.userMe);
      final request = http.MultipartRequest('PATCH', uri);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add fields
      request.fields['name'] = nameController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['country'] = countryController.text;
      request.fields['city'] = cityController.text;
      request.fields['state'] = stateController.text;
      request.fields['zip'] = zipController.text;

      if (selectedImage.value != null) {
        final file = selectedImage.value!;
        final multipartFile = await http.MultipartFile.fromPath(
          'image',
          file.path,
        );
        request.files.add(multipartFile);
      }

      if (kDebugMode) {
        print(
          'EditProfile: PATCH ${uri} fields=${request.fields} files=${request.files.length}',
        );
      }

      final streamedResp = await request.send();
      final resp = await http.Response.fromStream(streamedResp);
      if (kDebugMode) {
        print('EditProfile: PATCH status ${resp.statusCode} body ${resp.body}');
      }

      if (resp.statusCode == 200) {
        final jb = json.decode(resp.body);
        final success = jb['success'] == true;
        final message = jb['message'] ?? 'Profile updated';
        Get.back();
        if (success) {
          Get.snackbar('Success', message);
          await fetchProfile();
          return true;
        } else {
          Get.snackbar('Error', message.toString());
          return false;
        }
      } else {
        Get.snackbar('Error', 'Update failed: HTTP ${resp.statusCode}');
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('EditProfile: error saving profile: $e');
      Get.snackbar('Error', 'Failed to save changes: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Change password API call. Returns true on success.
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (!StorageService.isInitialized) await StorageService.init();
      final token = StorageService.token;
      final headers = {'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.changePassword);
      final body = json.encode({
        'password': currentPassword,
        'newPassword': newPassword,
      });
      if (kDebugMode) print('EditProfile: changePassword POST $uri');
      final resp = await http.post(uri, headers: headers, body: body);
      if (kDebugMode) {
        print(
          'EditProfile: changePassword status ${resp.statusCode} body ${resp.body}',
        );
      }
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final jb = json.decode(resp.body);
        final success = jb['success'] == true;
        final message = jb['message'] ?? 'Password changed';
        if (success) {
          // clear password fields
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          return true;
        } else {
          Get.snackbar('Error', message.toString());
          return false;
        }
      } else {
        Get.snackbar(
          'Error',
          'Password change failed: HTTP ${resp.statusCode}',
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) print('EditProfile: changePassword error: $e');
      Get.snackbar('Error', 'Failed to change password: $e');
      return false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    contactController.dispose();
    phoneController.dispose();
    countryController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
