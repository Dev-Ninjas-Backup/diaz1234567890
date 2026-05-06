// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class NeedHelpController extends GetxController {
  // Form Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final boatInfoController = TextEditingController();
  final commentsController = TextEditingController();

  final isLoading = false.obs;
  final isSending = false.obs;

  // Dynamic Content from API
  final address = ''.obs;
  final contactEmail = ''.obs;
  final contactPhone = ''.obs;
  final headerImageUrl = ''.obs;
  final workingHours = <dynamic>[].obs;
  final socialMedia = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNeedHelpData();
  }

  Future<void> fetchNeedHelpData() async {
    try {
      isLoading.value = true;
      final dio = Dio();
      final response = await dio.get(Endpoints.needHelp);

      print('=== NEED HELP RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Full Response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;

        address.value = data['address'] ?? data['contactAddress'] ?? '';
        contactEmail.value = data['email'] ?? data['contactEmail'] ?? '';
        contactPhone.value = data['phone'] ?? data['contactPhone'] ?? '';

        // Handle background image
        if (data['backgroundImage'] != null) {
          if (data['backgroundImage'] is String) {
            headerImageUrl.value = data['backgroundImage'];
          } else if (data['backgroundImage']['url'] != null) {
            headerImageUrl.value = data['backgroundImage']['url'];
          }
        } else if (data['headerImage'] != null) {
          headerImageUrl.value = data['headerImage'] is String
              ? data['headerImage']
              : data['headerImage']['url'] ?? '';
        }

        // Handle working hours
        if (data['workingHours'] != null) {
          workingHours.assignAll(data['workingHours']);
          print('Working Hours: ${workingHours.value}');
        }

        // Handle social media
        if (data['socialMedia'] != null) {
          socialMedia.assignAll(Map<String, dynamic>.from(data['socialMedia']));
          print('Social Media: ${socialMedia.value}');
        }

        print('=== DATA LOADED SUCCESSFULLY ===');
        print('Address: ${address.value}');
        print('Email: ${contactEmail.value}');
        print('Phone: ${contactPhone.value}');
        print('Header Image: ${headerImageUrl.value}');
      } else {
        print('ERROR: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('FETCH ERROR: $e');
      debugPrint('Error fetching help data: $e');
      Get.snackbar('Error', 'Failed to load contact information');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRequest() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar('Error', 'Full Name and Email are required');
      return;
    }

    isSending.value = true;
    try {
      final dio = Dio();
      final response = await dio.post(
        '${Endpoints.baseUrl}/api/contact/submit',
        data: {
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'boatInfo': boatInfoController.text,
          'comments': commentsController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Your request has been sent successfully.');
        // Clear form
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        boatInfoController.clear();
        commentsController.clear();
      } else {
        Get.snackbar('Error', 'Failed to send request. Please try again.');
      }
    } catch (e) {
      print('SUBMIT ERROR: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isSending.value = false;
    }
  }
}
