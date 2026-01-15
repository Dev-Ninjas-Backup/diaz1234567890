import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:diaz1234567890/core/endpoints/endpoints.dart';

class BoatSearchService {
  static Future<Map<String, dynamic>> queryBoats({
    required String query,
    required int limit,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({'query': query, 'limit': limit});

      if (kDebugMode) {
        print('BoatSearchService: POST ${Endpoints.floridaQuery}');
        print('BoatSearchService: Body: $body');
      }

      final response = await http
          .post(Uri.parse(Endpoints.floridaQuery), headers: headers, body: body)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (kDebugMode) {
        print('BoatSearchService: Status ${response.statusCode}');
        print('BoatSearchService: Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(
            errorData['error']?['message'] ??
                errorData['message'] ??
                'Failed to search boats (${response.statusCode})',
          );
        } catch (e) {
          throw Exception(
            'Failed to search boats (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('BoatSearchService: Error - $e');
      throw Exception('Error searching boats: $e');
    }
  }
}
