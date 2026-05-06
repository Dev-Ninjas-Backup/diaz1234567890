import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/features/ai/screen/ai_search_results_screen.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class YachtSearchPageController extends GetxController {
  YachtSearchPageController({required this.listingControllerTag});

  final String listingControllerTag;

  static const int aiLimit = 10;

  late final TextEditingController searchController;

  YachtSearchListingController get listingController =>
      Get.find<YachtSearchListingController>(tag: listingControllerTag);

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> handleAiSearch(String query) async {
    if (query.trim().isEmpty) {
      EasyLoading.showError('Please enter a search query');
      return;
    }

    try {
      listingController.isLoading.value = true;

      await StorageService.init();
      final userId = StorageService.userId;

      if (userId == null || userId.isEmpty) {
        EasyLoading.showError('User not logged in');
        return;
      }

      final response = await ApiService.aiSearch(query: query, limit: aiLimit);

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
        } catch (_) {}
      }

      Get.to(() => AiSearchResultsScreen(query: query, results: yachts));
    } catch (e) {
      EasyLoading.showError('Error: ${e.toString()}');
    } finally {
      listingController.isLoading.value = false;
    }
  }
}
