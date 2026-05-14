// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/features/about_us/model/mission_vision_model.dart';
import 'package:http/http.dart' as http;


class MissionVisionService {
  static Future<MissionVision> fetchMissionVision() async {
    try {
      print(
        '🔵 [MissionVisionService] Fetching mission/vision from: ${Endpoints.missionVision}',
      );

      final response = await http
          .get(Uri.parse(Endpoints.missionVision))
          .timeout(const Duration(seconds: 30));

      print(
        '🟢 [MissionVisionService] Response Status: ${response.statusCode}',
      );
      print('🟢 [MissionVisionService] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return MissionVision.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load mission/vision: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('🔴 [MissionVisionService] Error: $e');
      throw Exception('Error fetching mission/vision: $e');
    }
  }
}
