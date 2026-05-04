import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;

class TermsAndConditionService {
  Future<Map<String, dynamic>?> fetchTerms() async {
    try {
     final response = await http.get(Uri.parse(Endpoints.termsAndConditions));
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}