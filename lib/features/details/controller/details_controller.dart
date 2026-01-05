import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/boat_detail.dart';

class DetailsController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var boat = Rxn<BoatDetail>();
  var images = <String>[].obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // route argument expected to be the boat id
    final id = Get.arguments;
    if (id is String && id.isNotEmpty) {
      fetchBoatById(id);
    }
  }

  Future<void> fetchBoatById(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    images.clear();

    try {
      final token = StorageService.token;
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.getBoatById(id));
      if (kDebugMode) {
        print('Fetching boat by id: $uri');
        print('Auth token present: ${token != null && token.isNotEmpty}');
      }
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (kDebugMode) {
          print('Boat fetch response: ${response.body}');
        }
        if (jsonBody['success'] == true && jsonBody['data'] is Map) {
          final data = jsonBody['data'] as Map<String, dynamic>;
          final detail = BoatDetail.fromJson(data);
          boat.value = detail;

          // combine cover and gallery images for slider and thumbnails
          final imgs = <String>[];
          for (final im in detail.coverImages) {
            if (im.url.isNotEmpty) imgs.add(im.url);
          }
          for (final im in detail.galleryImages) {
            if (im.url.isNotEmpty) imgs.add(im.url);
          }
          if (kDebugMode) {
            print('Parsed coverImages: ${detail.coverImages.length}');
            print('Parsed galleryImages: ${detail.galleryImages.length}');
            print('Combined images count: ${imgs.length}');
          }
          images.addAll(imgs);
          if (images.isNotEmpty) currentIndex.value = 0;
        } else {
          errorMessage.value =
              jsonBody['message']?.toString() ?? 'Unexpected response';
        }
      } else {
        errorMessage.value = 'Failed to load boat (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
