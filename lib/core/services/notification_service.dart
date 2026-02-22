// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static Map<String, String> _headers() {
    final headers = {'Content-Type': 'application/json'};
    final token = StorageService.token;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Fetch all notifications for the current user
  static Future<List<Map<String, dynamic>>> getAll() async {
    final uri = Uri.parse(Endpoints.getUserAllNotifications);
    final resp = await http.get(uri, headers: _headers());
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);
      final data = jsonBody['data'];
      if (data is List) {
        return data
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load notifications: ${resp.statusCode}');
    }
  }

  /// Mark a single notification as read by sending notificationId
  static Future<Map<String, dynamic>> markOneAsRead(
    String notificationId,
  ) async {
    final uri = Uri.parse(Endpoints.markOneNotificationAsRead(notificationId));
    if (kDebugMode) print('NotificationService.markOneAsRead: PATCH $uri');
    final resp = await http.patch(uri, headers: _headers());
    if (kDebugMode)
      print(
        'NotificationService.markOneAsRead: status=${resp.statusCode} body=${resp.body}',
      );
    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);
      return Map<String, dynamic>.from(jsonBody['data'] ?? {});
    } else {
      throw Exception(
        'Failed to mark notification as read: ${resp.statusCode}',
      );
    }
  }

  /// Mark all notifications as read
  static Future<void> markAllAsRead() async {
    final uri = Uri.parse(Endpoints.markAllNotificationAsRead);
    if (kDebugMode) print('NotificationService.markAllAsRead: PATCH $uri');
    final resp = await http.patch(uri, headers: _headers());
    if (kDebugMode)
      print(
        'NotificationService.markAllAsRead: status=${resp.statusCode} body=${resp.body}',
      );
    if (resp.statusCode == 200) return;
    throw Exception('Failed to mark all as read: ${resp.statusCode}');
  }
}
