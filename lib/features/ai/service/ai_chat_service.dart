import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:diaz1234567890/core/endpoints/endpoints.dart';

class AiChatService {
  static Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String userId,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({'messages': message, 'user_id': userId});

      if (kDebugMode) {
        print('AiChatService: POST ${Endpoints.floridaChat}');
        print('AiChatService: Body: $body');
      }

      final response = await http
          .post(Uri.parse(Endpoints.floridaChat), headers: headers, body: body)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (kDebugMode) {
        print('AiChatService: Status ${response.statusCode}');
        print('AiChatService: Response: ${response.body}');
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(
            errorData['message'] ??
                'Failed to send message (${response.statusCode})',
          );
        } catch (e) {
          throw Exception(
            'Failed to send message (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('AiChatService: Error - $e');
      throw Exception('Error sending message: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getChatHistory({
    required String userId,
  }) async {
    try {
      final headers = {'Content-Type': 'application/json'};

      final uri = Uri.parse(
        Endpoints.floridaChatHistory,
      ).replace(queryParameters: {'user_id': userId});

      if (kDebugMode) {
        print('AiChatService: GET $uri');
      }

      final response = await http
          .get(uri, headers: headers)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (kDebugMode) {
        print('AiChatService: Status ${response.statusCode}');
        print('AiChatService: Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Handle different response formats
        if (jsonData is List) {
          return List<Map<String, dynamic>>.from(jsonData);
        } else if (jsonData is Map && jsonData['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonData['data']);
        } else {
          return [];
        }
      } else if (response.statusCode == 404) {
        // 404 for chat history is expected when no history exists yet
        // Treat as empty chat rather than an error
        if (kDebugMode) {
          print(
            'AiChatService: No chat history found (404) - returning empty list',
          );
        }
        return [];
      } else {
        try {
          final errorData = jsonDecode(response.body);
          throw Exception(
            errorData['message'] ??
                'Failed to fetch chat history (${response.statusCode})',
          );
        } catch (e) {
          throw Exception(
            'Failed to fetch chat history (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('AiChatService: Error - $e');
      throw Exception('Error fetching chat history: $e');
    }
  }
}
