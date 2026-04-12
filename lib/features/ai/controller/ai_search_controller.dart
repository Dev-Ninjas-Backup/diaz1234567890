// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/details/screen/details_screen.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AiSearchController extends GetxController {
  final String initialQuery;
  final List<Yacht> initialResults;

  AiSearchController({
    required this.initialQuery,
    required this.initialResults,
  });

  final searchController = TextEditingController();
  final isLoading = false.obs;
  final results = <Yacht>[].obs;
  final limit = 10.0.obs;
  final showLimitSlider = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController.text = initialQuery;
    results.addAll(initialResults);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleLimitSlider() => showLimitSlider.value = !showLimitSlider.value;

  void setLimit(double value) => limit.value = value;

  Future<void> handleAiSearch(String query) async {
    if (query.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a search query',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      await StorageService.init();
      final userId = StorageService.userId;

      if (userId == null || userId.isEmpty) {
        EasyLoading.showError('User not logged in');
        return;
      }

      final response = await ApiService.aiSearch(
        //userId: userId,
        query: query,
        limit: limit.value.toInt(),
      );

      if (response['error'] != null) {
        EasyLoading.showError(response['error'] ?? 'Search failed');
        return;
      }

      final data = response['data'] as List<dynamic>? ?? [];
      final yachts = <Yacht>[];

      for (final item in data) {
        try {
          final map = item as Map<String, dynamic>;
          String coverImageUrl = Imagepath.singleBoat;
          final images = map['images'];
          if (images is Map<String, dynamic> && images['Uri'] != null) {
            coverImageUrl = images['Uri'] as String;
          }
          final location = map['location'] as Map<String, dynamic>? ?? {};
          yachts.add(
            Yacht(
              id: map['document_id']?.toString() ?? '',
              title: '${map['make'] ?? ''} ${map['model'] ?? ''}'.trim(),
              location:
                  '${location['BoatCityName'] ?? ''}, ${location['BoatStateCode'] ?? ''}',
              make: map['make']?.toString() ?? 'N/A',
              model: map['model']?.toString() ?? 'N/A',
              year: map['model_year']?.toString() ?? 'N/A',
              price: map['price'] != null
                  ? '\$${(map['price'] as num).toStringAsFixed(0)}'
                  : 'Call for Price',
              image: coverImageUrl,
            ),
          );
        } catch (e) {
          print('Error parsing result: $e');
        }
      }

      results.assignAll(yachts);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('AI Search Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToDetails(String id) async {
    try {
      EasyLoading.show(status: 'Loading...');
      final response = await http.get(
        Uri.parse(Endpoints.getBoatById(id)),
        headers: {'Content-Type': 'application/json'},
      );
      final jsonBody = jsonDecode(response.body) as Map<String, dynamic>;
      EasyLoading.dismiss();

      if (response.statusCode == 200 && jsonBody['success'] == true) {
        Get.to(() => const DetailsScreen(), arguments: id);
      } else {
        final message =
            jsonBody['message']?.toString() ?? 'Failed to load boat details';
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        'Error',
        'Could not load boat details: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
