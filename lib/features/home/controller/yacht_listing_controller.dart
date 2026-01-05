import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/utils/constants/image_path.dart';
import '../../../core/endpoints/endpoints.dart';
import '../model/home_model.dart';

class YachtListingController extends GetxController {
  var featuredYachts = <Yacht>[].obs;
  var premiumDeals = <Yacht>[].obs;
  var isLoading = true.obs;
  var selectedTab = 0.obs;
  var selectedFeaturedSite = 'JUPITER'.obs;

  List<String> tabs = ["All", "Featured Yacht", "Premium Deals"];

  void changeTab(int index) {
    selectedTab.value = index;
    update();
    // when user switches tabs, load the appropriate data source
    if (index == 0) {
      // All tab - reload canonical /boats list
      fetchAllBoats();
    } else if (index == 1) {
      // Featured Yacht tab
      fetchFeaturedBoats(site: selectedFeaturedSite.value);
    } else if (index == 2) {
      // Premium Deals - load premium deals endpoint
      fetchPremiumDeals();
    }
  }

  List<Yacht> get currentYachts {
    switch (selectedTab.value) {
      case 0:
        return [...premiumDeals, ...featuredYachts];
      case 1:
        return featuredYachts;
      case 2:
        return premiumDeals;
      default:
        return [];
    }
  }

  Future<void> fetchForSite(String site) async {
    // Deprecated: use fetchAllBoats which queries the canonical /boats endpoint.
    // Keep this method for compatibility but delegate to fetchAllBoats.
    await fetchAllBoats();
  }

  Future<void> fetchBoth() async {
    isLoading.value = true;
    featuredYachts.clear();
    premiumDeals.clear();

    // For now use the generic /boats endpoint to populate the listing.
    await fetchAllBoats();

    isLoading.value = false;
  }

  // Fetch boats.
  Future<void> fetchAllBoats() async {
    try {
      final uri = Uri.parse(Endpoints.allBoats);
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

              final yacht = Yacht(
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
              if (kDebugMode) print('Error parsing boat item: $e');
            }
          }

          // Populate featured list with results. Premium/featured-specific APIs
          // will be added later; for now keep premium empty.
          featuredYachts.assignAll(yachts);
          premiumDeals.clear();
        }
      } else {
        if (kDebugMode) print('Failed to fetch boats: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching boats: $e');
    }
  }

  /// Fetch featured boats for a given site (e.g., JUPITER or FLORIDA).
  Future<void> fetchFeaturedBoats({required String site}) async {
    isLoading.value = true;
    try {
      final uri = Uri.parse('${Endpoints.featuredBoats}?site=$site');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] is Map) {
          final data = jsonData['data'] as Map<String, dynamic>;
          final boatData = data['boat'] ?? data;

          String coverImageUrl = Imagepath.singleBoat;
          final images =
              boatData['images'] as List<dynamic>? ??
              boatData['Images'] as List<dynamic>? ??
              [];
          if (images.isNotEmpty) {
            final first = images.firstWhere(
              (img) =>
                  img != null && (img['Uri'] != null || img['file'] != null),
              orElse: () => images[0],
            );
            if (first != null) {
              if (first['Uri'] != null) {
                coverImageUrl = first['Uri'] as String;
              } else if (first['file'] != null &&
                  first['file']['url'] != null) {
                coverImageUrl = first['file']['url'] as String;
              }
            }
          }

          final yacht = Yacht(
            title:
                boatData['name'] ?? boatData['ListingTitle'] ?? 'Unknown Yacht',
            location:
                '${boatData['city'] ?? boatData['BoatLocation']?['BoatCityName'] ?? ''}, ${boatData['state'] ?? boatData['BoatLocation']?['BoatStateCode'] ?? ''}',
            make: boatData['make'] ?? boatData['MakeString'] ?? 'N/A',
            model: boatData['model'] ?? boatData['Model'] ?? 'N/A',
            year:
                boatData['buildYear']?.toString() ??
                boatData['ModelYear']?.toString() ??
                'N/A',
            price: boatData['price'] != null && boatData['price'] is num
                ? "\$${(boatData['price'] as num).toStringAsFixed(0)}"
                : (boatData['Price']?.toString() ?? 'Call for Price'),
            image: coverImageUrl,
          );

          featuredYachts.assignAll([yacht]);
          premiumDeals.clear();
        }
      } else {
        if (kDebugMode)
          print('Failed to fetch featured boats: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching featured boats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch premium deals (Florida) and populate `premiumDeals`.
  Future<void> fetchPremiumDeals() async {
    isLoading.value = true;
    try {
      final uri = Uri.parse(Endpoints.premiumDeals);
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

              final yacht = Yacht(
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
              if (kDebugMode) print('Error parsing premium item: $e');
            }
          }

          premiumDeals.assignAll(yachts);
        }
      } else {
        if (kDebugMode)
          print('Failed to fetch premium deals: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching premium deals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBoth();
  }
}
