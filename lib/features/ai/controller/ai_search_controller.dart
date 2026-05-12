// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/details/screen/details_screen.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:flutter/foundation.dart';
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

  final galleryImages = <String, List<String>>{}.obs;
  final currentGalleryIndex = <String, int>{}.obs;

  int currentPage = 1;
  final totalResults = 0.obs; 
  final isLoadingMore = false.obs;
  final isFromFilters = false.obs;

  bool _shouldRefreshFromApi() {
    if (initialResults.isEmpty) return true;
    final allPlaceholders = initialResults.every(
      (yacht) => !yacht.image.startsWith('http'),
    );
    return allPlaceholders;
  }

  @override
  void onInit() {
    super.onInit();
    searchController.text = initialQuery;
    results.addAll(initialResults);

    if (_shouldRefreshFromApi()) {
      // Fetch fresh AI results so image URLs come from backend.
      handleAiSearch(initialQuery);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleLimitSlider() => showLimitSlider.value = !showLimitSlider.value;

  void setLimit(double value) => limit.value = value;

  // Helper method to parse yacht data from API response
  List<Yacht> _parseYachtsFromResponse(List<dynamic> data) {
    final yachts = <Yacht>[];

    for (final item in data) {
      try {
        final map = item as Map<String, dynamic>;
        final documentId = map['document_id']?.toString() ?? '';
        String coverImageUrl = Imagepath.singleBoat;

        // Handle images array from API response - populate gallery
        final images = (map['images'] ?? map['Images']) as List<dynamic>? ?? [];
        final galleryUrls = <String>[];

        if (images.isNotEmpty) {
          print('AI raw images for $documentId: $images');

          // Extract ALL image URLs in backend order (preserve order)
          for (final img in images) {
            if (img != null && img is Map && img['Uri'] != null) {
              final uri = img['Uri'] as String;
              if (uri.isNotEmpty) {
                galleryUrls.add(uri);
              }
            }
          }

          print('AI image list for $documentId: $galleryUrls');

          // Use first extracted URL as cover
          if (galleryUrls.isNotEmpty) {
            coverImageUrl = galleryUrls[0];
          }

          print('AI cover image for $documentId: $coverImageUrl');

          // Store gallery for this yacht (preserve backend order)
          if (documentId.isNotEmpty) {
            galleryImages[documentId] = galleryUrls;
            currentGalleryIndex[documentId] = 0;
          }
        } else {
          print('AI images empty for $documentId');
        }

        final location = map['location'] as Map<String, dynamic>? ?? {};
        yachts.add(
          Yacht(
            id: documentId,
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
        if (kDebugMode) print('Error parsing AI search result: $e');
      }
    }

    return yachts;
  }

  Future<void> handleAiSearch(String query) async {
    if (query.trim().isEmpty) {
      EasyLoading.showError('Please enter a search query');
      return;
    }

    try {
      isLoading.value = true;
      currentPage = 1; 
      isFromFilters.value = false; 

      final response = await ApiService.aiSearch(
        query: query,
        limit: limit.value.toInt(),
      );

      if (response['error'] != null) {
        EasyLoading.showError(response['error'] ?? 'Search failed');
        return;
      }

      final data = response['data'] as List<dynamic>? ?? [];

      final yachts = _parseYachtsFromResponse(data);

      final receivedCount = yachts.length;
      if (receivedCount < limit.value.toInt()) {
        totalResults.value = receivedCount;
      } else {
        totalResults.value = (receivedCount * 1.5).toInt();
      }

      results.assignAll(yachts);
      print(
        '✅ AI Search completed. Total results: ${totalResults.value}, Loaded: ${results.length}',
      );
    } catch (e) {
      EasyLoading.showError('Error: ${e.toString()}');
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
        EasyLoading.showError(message);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Could not load boat details: $e');
    }
  }

  // Fetch more results with pagination (matching SearchScreenController pattern)
  Future<void> fetchMoreResults(int newLimit) async {
    try {
      isLoadingMore.value = true;
      print('📥 Fetching more AI search results with limit: $newLimit');

      final newLimitInt = newLimit.toInt();
      limit.value = newLimitInt.toDouble();

      // Call AI search with the new limit
      await performAiSearchWithLimit(searchController.text, newLimitInt);
    } catch (e) {
      print('❌ Error fetching more results: $e');
      EasyLoading.showError('Error loading more results: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Perform AI search with a specific limit
  Future<void> performAiSearchWithLimit(String query, int limitValue) async {
    if (query.trim().isEmpty) {
      EasyLoading.showError('Please enter a search query');
      return;
    }

    try {
      print('📤 Performing AI search - Query: $query, Limit: $limitValue');

      final response = await ApiService.aiSearch(
        query: query,
        limit: limitValue,
      );

      if (response['error'] != null) {
        EasyLoading.showError(response['error'] ?? 'Search failed');
        return;
      }

      final data = response['data'] as List<dynamic>? ?? [];

      // Parse new yachts using helper
      final newYachts = _parseYachtsFromResponse(data);

      // Deduplicate: only add yachts that aren't already in results
      final existingIds = results.map((y) => y.id).toSet();
      final uniqueNewYachts = newYachts
          .where((yacht) => !existingIds.contains(yacht.id))
          .toList();

      results.addAll(uniqueNewYachts);


      final receivedCount = newYachts.length;
      if (receivedCount < limitValue) {
        totalResults.value = results.length;
      } else {
        totalResults.value = (results.length * 1.5).toInt(); 
      }

      print(
        '✅ Added ${uniqueNewYachts.length} more AI results. Total now: ${results.length}/${totalResults.value}',
      );
    } catch (e) {
      print('❌ Error in performAiSearchWithLimit: $e');
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }
}
