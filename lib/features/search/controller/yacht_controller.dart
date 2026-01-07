import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../../core/utils/constants/image_path.dart';
import '../../../core/endpoints/endpoints.dart';
import '../model/yacht_model.dart';

class YachtSearchListingController extends GetxController {
  var similarYachts = <Yacht>[].obs;
  var models = <String>[].obs;
  var classes = <String>[].obs;
  var isLoading = false.obs;

  // Filter state
  var selectedModel = RxnString();
  var selectedClass = RxnString();
  var selectedYear = RxnString();
  var selectedPrice = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchFilterOptions();
    // Fetch all boats initially
    performSearch();
    // Listen to filter changes and trigger search
    ever(selectedModel, (_) => performSearch());
    ever(selectedClass, (_) => performSearch());
    ever(selectedYear, (_) => performSearch());
    ever(selectedPrice, (_) => performSearch());
  }

  Future<void> fetchFilterOptions() async {
    try {
      final uri = Uri.parse(Endpoints.filters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final modelsData =
            (jsonData['models'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        final classesData =
            (jsonData['classes'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];
        models.assignAll(modelsData);
        classes.assignAll(classesData);
        if (kDebugMode)
          print(
            'Filter options loaded: models=${models.length}, classes=${classes.length}',
          );
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching filter options: $e');
    }
  }

  Future<void> performSearch() async {
    isLoading.value = true;
    try {
      final params = <String, String>{};
      if (selectedModel.value != null && selectedModel.value!.isNotEmpty) {
        params['model'] = selectedModel.value!;
      }
      if (selectedClass.value != null && selectedClass.value!.isNotEmpty) {
        params['class'] = selectedClass.value!;
      }
      if (selectedYear.value != null && selectedYear.value!.isNotEmpty) {
        params['buildYear'] = selectedYear.value!;
      }
      if (selectedPrice.value != null && selectedPrice.value!.isNotEmpty) {
        params['priceEnd'] = selectedPrice.value!;
      }

      final uri = Uri.parse(
        Endpoints.allBoats,
      ).replace(queryParameters: params.isNotEmpty ? params : null);
      if (kDebugMode) print('Search query: $uri');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] is List) {
          final items = jsonData['data'] as List<dynamic>;
          final yachts = <Yacht>[];

          for (final item in items) {
            try {
              final map = item as Map<String, dynamic>;
              final images = map['Images'] as List<dynamic>? ?? [];
              String coverImageUrl = Imagepath.singleBoat;
              if (images.isNotEmpty) {
                final first = images.firstWhere(
                  (img) => img != null && img['Uri'] != null,
                  orElse: () => images[0],
                );
                if (first != null && first['Uri'] != null) {
                  coverImageUrl = first['Uri'] as String;
                }
              }

              final id =
                  (map['DocumentID'] ?? map['id'] ?? map['listingId'] ?? '')
                      .toString();
              final yacht = Yacht(
                id: id,
                title: map['ListingTitle'] ?? 'Unknown Yacht',
                location:
                    '${map['BoatLocation']?['BoatCityName'] ?? ''}, ${map['BoatLocation']?['BoatStateCode'] ?? ''}',
                make: map['MakeString'] ?? 'N/A',
                model: map['Model'] ?? 'N/A',
                year: map['ModelYear']?.toString() ?? 'N/A',
                price: map['Price']?.toString() ?? 'Call for Price',
                image: coverImageUrl,
              );
              yachts.add(yacht);
            } catch (e) {
              if (kDebugMode) print('Error parsing search result: $e');
            }
          }
          similarYachts.assignAll(yachts);
          if (kDebugMode) print('Search returned ${yachts.length} boats');
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error performing search: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
