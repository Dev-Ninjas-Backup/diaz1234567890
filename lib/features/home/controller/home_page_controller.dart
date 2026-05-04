// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/ai/screen/ai_search_results_screen.dart';
import 'package:diaz1234567890/features/home/controller/yacht_listing_controller.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final searchTextController = TextEditingController();

  late final YachtListingController listingController;
  late final YachtSearchListingController aiSearchController;

  @override
  void onInit() {
    super.onInit();
    listingController = Get.put(YachtListingController());
    aiSearchController = Get.put(
      YachtSearchListingController(),
      tag: 'home_search',
    );

    // Set FLORIDA as default site
    listingController.selectedFeaturedSite.value = 'FLORIDA';
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  void openFilterSheet() {
    // This is wired in the view to avoid circular imports (widget depends on FilterBottomSheet).
  }

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
      aiSearchController.isLoading.value = true;

      await StorageService.init();
      final userId = StorageService.userId;
      if (userId == null || userId.isEmpty) {
        EasyLoading.showError('User not logged in');
        return;
      }

      final response = await ApiService.aiSearch(
        query: query,
        // Keep it small to avoid heavy parsing on home.
        limit: 20,
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

          var coverImageUrl = Imagepath.singleBoat;
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

      Get.to(() => AiSearchResultsScreen(query: query, results: yachts));
    } catch (e) {
      EasyLoading.showError('Search failed: $e');
      print('AI Search Error: $e');
    } finally {
      aiSearchController.isLoading.value = false;
    }
  }
}
