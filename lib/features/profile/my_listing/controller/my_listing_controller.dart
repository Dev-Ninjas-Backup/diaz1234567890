import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import '../model/boat.dart';

class MyListingController extends GetxController {
  var isLoading = false.obs;
  var boats = <Boat>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyBoats();
  }

  Future<void> fetchMyBoats() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = StorageService.token;
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.getMyBoats);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] is List) {
          final List data = jsonBody['data'];
          boats.value = data
              .map((e) => Boat.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          errorMessage.value =
              jsonBody['message']?.toString() ?? 'Unexpected response';
        }
      } else {
        errorMessage.value = 'Failed to load boats (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteBoat(String boatId) async {
    try {
      final token = StorageService.token;
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.deleteBoat(boatId));
      final response = await http.delete(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true) {
          // Remove the boat from the list
          boats.removeWhere(
            (boat) => boat.id == boatId || boat.listingId == boatId,
          );
          EasyLoading.showSuccess(
            jsonBody['message']?.toString() ?? 'Boat deleted successfully',
          );
          return true;
        } else {
          EasyLoading.showError(
            jsonBody['message']?.toString() ?? 'Failed to delete boat',
          );
          return false;
        }
      } else {
        EasyLoading.showError('Failed to delete boat (${response.statusCode})');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Network error: $e');
      return false;
    }
  }
}
