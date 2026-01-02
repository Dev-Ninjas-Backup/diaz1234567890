import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      'https://api.floridayachttrader.com'; // Replace with your actual base URL

  static Future<dynamic> getSubscriptionPlans() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/subscription/plans'))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plans: $e');
    }
  }

  static Future<dynamic> createBoatOnboarding({
    required Map<String, dynamic> boatInfo,
    required Map<String, dynamic> sellerInfo,
    required String planId,
  }) async {
    try {
      final requestBody = {
        'boatInfo': boatInfo,
        'sellerInfo': sellerInfo,
        'planId': planId,
      };

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/boats/seller/onboarding'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Failed to create boat listing: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating boat listing: $e');
    }
  }
}
