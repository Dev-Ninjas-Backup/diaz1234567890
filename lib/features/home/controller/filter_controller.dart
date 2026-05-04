// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:diaz1234567890/features/search/model/yacht_model.dart'
    as search_model;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FilterController extends GetxController {
  FilterController({required this.searchControllerTag});

  final String searchControllerTag;
  static const int _pageSize = 10;

  final currentPage = 1.obs;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  Map<String, String> _baseParams = const {};

  // Options from API (best-effort; keys may differ)
  final makes = <String>[].obs;
  final models = <String>[].obs;
  final classes = <String>[].obs;
  final locations = <String>[].obs;

  // Selected filters
  final selectedMake = RxnString();
  final selectedModel = RxnString();
  final selectedClass = RxnString();
  final selectedLocation = RxnString();

  // Ranges / numbers
  final priceStart = 0.0.obs;
  final priceEnd = 5000000.0.obs;

  final buildYearStartController = TextEditingController();
  final buildYearEndController = TextEditingController();
  final lengthStartController = TextEditingController();
  final lengthEndController = TextEditingController();
  final beamStartController = TextEditingController();
  final beamEndController = TextEditingController();
  final enginesNumberController = TextEditingController();
  final headsNumberController = TextEditingController();
  final cabinsNumberController = TextEditingController();

  final isLoadingFilterOptions = false.obs;
  final isApplyingFilters = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFilterOptions();
  }

  @override
  void onClose() {
    buildYearStartController.dispose();
    buildYearEndController.dispose();
    lengthStartController.dispose();
    lengthEndController.dispose();
    beamStartController.dispose();
    beamEndController.dispose();
    enginesNumberController.dispose();
    headsNumberController.dispose();
    cabinsNumberController.dispose();
    super.onClose();
  }

  Future<void> fetchFilterOptions() async {
    isLoadingFilterOptions.value = true;
    try {
      final response = await http.get(Uri.parse(Endpoints.filters));
      if (response.statusCode != 200) return;

      final jsonData = jsonDecode(response.body);
      if (jsonData is! Map<String, dynamic>) return;

      List<String> readStringList(String key) {
        final raw = jsonData[key];
        if (raw is! List) return const <String>[];
        return raw.map((e) => e.toString()).toList();
      }

      // Current API supports at least `models` + `classes`.
      // Keep extra keys optional so UI doesn't break if absent.
      models.assignAll(readStringList('models'));
      classes.assignAll(readStringList('classes'));
      makes.assignAll(readStringList('makes'));
      locations.assignAll(readStringList('locations'));
    } catch (e) {
      if (kDebugMode) print('Filter options error: $e');
    } finally {
      isLoadingFilterOptions.value = false;
    }
  }

  void resetFilters() {
    selectedMake.value = null;
    selectedModel.value = null;
    selectedClass.value = null;
    selectedLocation.value = null;

    priceStart.value = 0;
    priceEnd.value = 5000000;

    buildYearStartController.clear();
    buildYearEndController.clear();
    lengthStartController.clear();
    lengthEndController.clear();
    beamStartController.clear();
    beamEndController.clear();
    enginesNumberController.clear();
    headsNumberController.clear();
    cabinsNumberController.clear();
  }

  Future<void> applyFilters() async {
    isApplyingFilters.value = true;
    final searchController = Get.find<YachtSearchListingController>(
      tag: searchControllerTag,
    );
    searchController.isLoading.value = true;
    try {
      currentPage.value = 1;
      hasMore.value = true;
      _baseParams = _buildBaseParams();

      await _fetchPage(
        page: 1,
        append: false,
      );
    } catch (e) {
      if (kDebugMode) print('❌ Error applying filters: $e');
      Get.snackbar('Error', 'Failed to apply filters');
      rethrow;
    } finally {
      searchController.isLoading.value = false;
      isApplyingFilters.value = false;
    }
  }

  Future<void> fetchNextPage() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    try {
      final nextPage = currentPage.value + 1;
      await _fetchPage(page: nextPage, append: true);
      currentPage.value = nextPage;
    } finally {
      isLoadingMore.value = false;
    }
  }

  Map<String, String> _buildBaseParams() {
    final params = <String, String>{};

    void addIfNotEmpty(String key, String? value) {
      final v = value?.trim();
      if (v == null || v.isEmpty) return;
      params[key] = v;
    }

    addIfNotEmpty('make', selectedMake.value);
    addIfNotEmpty('model', selectedModel.value);
    addIfNotEmpty('class', selectedClass.value);
    addIfNotEmpty('location', selectedLocation.value);

    addIfNotEmpty('buildYearStart', buildYearStartController.text);
    addIfNotEmpty('buildYearEnd', buildYearEndController.text);
    addIfNotEmpty('lengthStart', lengthStartController.text);
    addIfNotEmpty('lengthEnd', lengthEndController.text);
    addIfNotEmpty('beamSizeStart', beamStartController.text);
    addIfNotEmpty('beamSizeEnd', beamEndController.text);
    addIfNotEmpty('enginesNumber', enginesNumberController.text);
    addIfNotEmpty('headsNumber', headsNumberController.text);
    addIfNotEmpty('cabinsNumber', cabinsNumberController.text);

    if (priceStart.value > 0) {
      params['priceStart'] = priceStart.value.toInt().toString();
    }
    params['priceEnd'] = priceEnd.value.toInt().toString();

    return params;
  }

  Future<void> _fetchPage({required int page, required bool append}) async {
    final searchController = Get.find<YachtSearchListingController>(
      tag: searchControllerTag,
    );

    final params = <String, String>{
      ..._baseParams,
      'page': page.toString(),
      'limit': _pageSize.toString(),
    };

    final uri = Uri.parse(Endpoints.allBoats).replace(queryParameters: params);
    if (kDebugMode) print('📤 Filter query: $uri');

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }

    final jsonData = jsonDecode(response.body);
    final yachts = _parseBoatsToYachts(jsonData);

    if (append) {
      searchController.similarYachts.addAll(yachts);
    } else {
      searchController.similarYachts.assignAll(yachts);
    }

    // If API returns fewer than page size, assume no more pages.
    if (yachts.length < _pageSize) {
      hasMore.value = false;
    }
  }

  List<search_model.Yacht> _parseBoatsToYachts(dynamic jsonData) {
    final data = (jsonData is Map<String, dynamic>) ? jsonData['data'] : null;
    if (data is! List) return const <search_model.Yacht>[];

    final yachts = <search_model.Yacht>[];
    for (final item in data) {
      if (item is! Map<String, dynamic>) continue;
      try {
        final images = item['Images'] as List<dynamic>? ?? const [];
        var coverImageUrl = Imagepath.singleBoat;
        if (images.isNotEmpty) {
          final first = images.firstWhere(
            (img) => img != null && img is Map && img['Uri'] != null,
            orElse: () => images[0],
          );
          if (first is Map && first['Uri'] != null) {
            coverImageUrl = first['Uri'].toString();
          }
        }

        final id =
            (item['DocumentID'] ?? item['id'] ?? item['listingId'] ?? '')
                .toString();
        final location = item['BoatLocation'] as Map<String, dynamic>? ?? {};

        yachts.add(
          search_model.Yacht(
            id: id,
            title: item['ListingTitle']?.toString() ?? 'Unknown Yacht',
            location:
                '${location['BoatCityName'] ?? ''}, ${location['BoatStateCode'] ?? ''}',
            make: item['MakeString']?.toString() ?? 'N/A',
            model: item['Model']?.toString() ?? 'N/A',
            year: item['ModelYear']?.toString() ?? 'N/A',
            price: item['Price']?.toString() ?? 'Call for Price',
            image: coverImageUrl,
          ),
        );
      } catch (e) {
        if (kDebugMode) print('Error parsing filtered result: $e');
      }
    }
    return yachts;
  }
}
