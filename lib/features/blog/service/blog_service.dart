// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/features/blog/model/blog_model.dart';
import 'package:http/http.dart' as http;


class BlogService {
  static Future<List<Blog>> fetchBlogs() async {
    try {
      print('🔵 [BlogService] Fetching blogs from: ${Endpoints.blogPosts}');

      final response = await http
          .get(Uri.parse(Endpoints.blogPosts))
          .timeout(Duration(seconds: 30));

      print('🟢 [BlogService] Response Status: ${response.statusCode}');
      print('🟢 [BlogService] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        final List<Blog> blogs = jsonData
            .map((blog) => Blog.fromJson(blog))
            .toList();

        blogs.forEach((blog) {});

        return blogs;
      } else {
        throw Exception('Failed to load blogs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching blogs: $e');
    }
  }
}
