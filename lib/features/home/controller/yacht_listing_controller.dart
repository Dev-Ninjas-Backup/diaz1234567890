import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/utils/constants/image_path.dart';
import '../model/home_model.dart';

class YachtListingController extends GetxController {
  var featuredYachts = <Yacht>[].obs;
  var premiumDeals = <Yacht>[].obs;
  var isLoading = true.obs;

  Future<void> fetchForSite(String site) async {
    try {
      final url =
          'https://api.floridayachttrader.com/api/boats/featured?site=$site';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {
          final boatData = jsonData['data']['boat'];

          String coverImageUrl = Imagepath.singleBoat;
          final images = boatData['images'] as List<dynamic>? ?? [];
          final coverImage = images.firstWhere(
            (img) => img['imageType'] == 'COVER',
            orElse: () => images.isNotEmpty ? images[0] : null,
          );
          if (coverImage != null && coverImage['file'] != null) {
            coverImageUrl = coverImage['file']['url'];
          }

          final yacht = Yacht(
            title: boatData['name'] ?? 'Unknown Yacht',
            location: '${boatData['city'] ?? ''}, ${boatData['state'] ?? ''}',
            make: boatData['make'] ?? 'N/A',
            model: boatData['model'] ?? 'N/A',
            year: boatData['buildYear']?.toString() ?? 'N/A',
            price: boatData['price'] != null
                ? "\$${boatData['price'].toStringAsFixed(0)}"
                : 'Call for Price',
            image: coverImageUrl,
          );

          if (site == 'JUPITER') {
            featuredYachts.add(yacht);
          } else if (site == 'FLORIDA') {
            premiumDeals.add(yacht);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching for $site: $e');
      }
    }
  }

  Future<void> fetchBoth() async {
    isLoading.value = true;
    featuredYachts.clear();
    premiumDeals.clear();

    await Future.wait([fetchForSite('FLORIDA'), fetchForSite('JUPITER')]);

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fetchBoth();
  }
}
