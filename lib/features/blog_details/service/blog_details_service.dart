// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/features/blog_details/model/blog_details_model.dart';
import 'package:http/http.dart' as http;

class BlogDetailsService {
  static Future<BlogDetails> fetchBlogDetails(String documentId) async {
    try {
      final String url = Endpoints.blogDetails(documentId);

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      print('🟢 [BlogDetailsService] Status Code: ${response.statusCode}');
      print('🟢 [BlogDetailsService] Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to load blog details: ${response.statusCode}');
      }

      final dynamic decoded = json.decode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected blog details response format');
      }

      final dynamic data = decoded['data'];
      final Map<String, dynamic> blogJson = data is Map<String, dynamic>
          ? data
          : decoded;

      print(
        '🟣 [BlogDetailsService] Parsed blog id: ${blogJson['id']}, title: ${blogJson['blogTitle']}',
      );

      return BlogDetails.fromJson(blogJson);
    } catch (e) {
      print('🔴 [BlogDetailsService] Error: $e');
      throw Exception('Error fetching blog details: $e');
    }
  }
}
