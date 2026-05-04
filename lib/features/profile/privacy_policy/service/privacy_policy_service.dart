import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class PrivacyService {
  Future<Map<String, dynamic>?> fetchPrivacyPolicy() async {
    try {
     final response = await http.get(Uri.parse(Endpoints.privacyPolicy));

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching privacy: $e');
    }
    return null;
  }
}