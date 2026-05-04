import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import '../model/boat_detail.dart';

// for geocoding
import 'package:http/http.dart' as http_client;
import 'dart:async';

class DetailsController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var boat = Rxn<BoatDetail>();
  var images = <String>[].obs;
  // Geocoded location for the boat (nullable)
  var location = Rxn<LatLng>();

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> _geocodeBoatLocation(String? city, String? state) async {
    location.value = null;
    final parts = <String>[];
    if (city != null && city.isNotEmpty) parts.add(city);
    if (state != null && state.isNotEmpty) parts.add(state);
    if (parts.isEmpty) return;

    final query = Uri.encodeComponent(parts.join(', '));
    final url =
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1';

    try {
      final resp = await http_client.get(
        Uri.parse(url),
        headers: {'User-Agent': 'diaz1234567890/1.0 (you@yourdomain.com)'},
      );
      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);
        if (body is List && body.isNotEmpty) {
          final item = body[0];
          final lat = double.tryParse(item['lat'].toString());
          final lon = double.tryParse(item['lon'].toString());
          if (lat != null && lon != null) {
            location.value = LatLng(lat, lon);
            if (kDebugMode) {
              print('Geocoded location: $lat,$lon for ${parts.join(', ')}');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print('Geocoding failed: $e');
    }
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
        //print('Auth token present: ${token != null && token.isNotEmpty}');
      }
      final response = await http.get(uri);

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
          // attempt to geocode the boat's city/state to a lat/lng
          await _geocodeBoatLocation(detail.city, detail.state);
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
