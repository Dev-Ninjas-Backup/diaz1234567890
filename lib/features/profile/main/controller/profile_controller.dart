import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/core/services/socket_service.dart';
import 'package:diaz1234567890/core/services/notification_service.dart';

class ProfileController extends GetxController {
  final privacyToggle = false.obs;
  final notificationToggle = true.obs;

  // notifications list stores server objects; use Obx list for UI binding
  final notifications = <Map<String, dynamic>>[].obs;

  // user info
  final userName = RxnString();
  final avatarUrl = RxnString();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    _restoreNotificationPreference();
  }

  StreamSubscription<Map<String, dynamic>>? _notifSub;

  void _subscribeToSocket() {
    // user enabled notifications: connect socket and listen for events
    SocketService().connect();

    // avoid creating multiple subscriptions
    _notifSub ??= SocketService().notifications.listen((payload) async {
      try {
        Map<String, dynamic> top;
        if (payload.containsKey('notification')) {
          top = Map<String, dynamic>.from(payload);
        } else if (payload['id'] != null) {
          top = Map<String, dynamic>.from(payload);
        } else {
          top = {
            'id': payload['id'] ?? UniqueKey().toString(),
            'read': false,
            'notification': payload,
          };
        }

        // insert into local list
        notifications.insert(0, top);

        final notif = top['notification'] is Map
            ? Map<String, dynamic>.from(top['notification'])
            : <String, dynamic>{};

        final title = notif['title']?.toString() ?? 'Notification';
        final message = notif['message']?.toString() ?? '';

        // Show a lightweight in-app alert while app is active
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );

        // Optionally refresh server-side list (non-blocking)
        try {
          await loadNotifications();
        } catch (_) {}
      } catch (e) {
        if (kDebugMode) print('Notification handling error: $e');
      }
    });
  }

  void _unsubscribeFromSocket() {
    _notifSub?.cancel();
    _notifSub = null;
    SocketService().disconnect();
  }

  void _restoreNotificationPreference() async {
    try {
      if (!StorageService.isInitialized) await StorageService.init();
      final enabled = StorageService.notificationsEnabled;
      notificationToggle.value = enabled;
      if (enabled) {
        _subscribeToSocket();
        await loadNotifications();
      }
    } catch (e) {
      if (kDebugMode) print('Failed to restore notification preference: $e');
    }
  }

  /// Load notifications from server into `notifications` list
  Future<void> loadNotifications() async {
    try {
      final list = await NotificationService.getAll();
      // only keep unread notifications for the in-app list
      final unread = list.where((e) => e['read'] != true).toList();
      notifications.clear();
      notifications.addAll(unread);
    } catch (e) {
      if (kDebugMode) print('Failed to load notifications: $e');
    }
  }

  /// Mark a single notification (by top-level id) as read and update local state
  Future<void> markOneRead(String id) async {
    try {
      // The server expects the notification identifier (often the nested
      // `notification.id` or a `notificationId` field). Accept either a
      // top-level id or a nested notification id here.
      String? notificationId;
      // try to find the item by top-level id first
      final idx = notifications.indexWhere((e) => e['id'] == id);
      if (idx != -1) {
        final candidate = notifications[idx];
        if (candidate['notificationId'] != null) {
          notificationId = candidate['notificationId'].toString();
        }
      }

      // fallback: assume passed `id` is the notificationId
      notificationId ??= id;

      final updated = await NotificationService.markOneAsRead(notificationId);

      // Server returns the top-level record (with its own `id`) in `updated`.
      // Try to update the local list by matching either top-level id or
      // returned `notificationId`.
      String? returnedId = updated['id']?.toString();
      String? returnedNotificationId = updated['notificationId']?.toString();

      // prefer updating by top-level id if available
      int found = -1;
      if (returnedId != null) {
        found = notifications.indexWhere((e) => e['id'] == returnedId);
      }
      if (found == -1 && returnedNotificationId != null) {
        found = notifications.indexWhere(
          (e) =>
              (e['notificationId'] != null &&
              e['notificationId'] == returnedNotificationId),
        );
      }

      if (found != -1) {
        // Remove item from visible list when marked read
        notifications.removeAt(found);
      }
    } catch (e) {
      if (kDebugMode) print('markOneRead error: $e');
    }
  }

  Future<void> markAllRead() async {
    try {
      await NotificationService.markAllAsRead();
      // Clear local list since all are now read
      notifications.clear();
    } catch (e) {
      if (kDebugMode) print('markAllRead error: $e');
    }
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      // Ensure SharedPreferences (StorageService) is initialized before
      // reading the token. This avoids a null token when init hasn't run yet.
      if (!StorageService.isInitialized) {
        if (kDebugMode) print('StorageService not initialized; calling init()');
        await StorageService.init();
      }

      final token = StorageService.token;
      if (kDebugMode) {
        print(
          'Profile fetch: token present=${token != null && token.isNotEmpty}',
        );
      }

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.userMe);
      if (kDebugMode) print('Profile fetch: GET $uri');
      final resp = await http.get(uri, headers: headers);
      if (kDebugMode) print('Profile fetch status: ${resp.statusCode}');

      // Log body for debugging (only in debug builds)
      if (kDebugMode) {
        try {
          print('Profile fetch body: ${resp.body}');
        } catch (_) {}
      }

      if (resp.statusCode == 200) {
        final jsonBody = json.decode(resp.body);

        // Support multiple possible response shapes:
        // 1) { success: true, data: { name:..., avatarUrl:... } }
        // 2) { success: true, data: { user: { ... } } }
        // 3) { user: { ... } }
        Map<String, dynamic>? data;

        if (jsonBody['success'] == true && jsonBody['data'] is Map) {
          final d = jsonBody['data'] as Map<String, dynamic>;
          if (d['user'] is Map) {
            data = d['user'] as Map<String, dynamic>;
          } else {
            data = d;
          }
        } else if (jsonBody['user'] is Map) {
          data = jsonBody['user'] as Map<String, dynamic>;
        } else if (jsonBody is Map &&
            jsonBody['data'] == null &&
            jsonBody['name'] != null) {
          // sometimes API returns the user object directly
          data = Map<String, dynamic>.from(jsonBody);
        }

        if (data != null) {
          userName.value = (data['name'])?.toString() ?? '';
          avatarUrl.value = (data['avatarUrl'])?.toString();
          if (kDebugMode) {
            print(
              'Profile parsed: name=${userName.value}, avatar=${avatarUrl.value}',
            );
          }
        } else {
          if (kDebugMode) print('Profile fetch: unexpected JSON shape');
        }
      } else {
        if (kDebugMode) print('Profile fetch failed: HTTP ${resp.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void togglePrivacy() => privacyToggle.value = !privacyToggle.value;

  void toggleNotification() {
    // flip the toggle state first so UI updates immediately
    notificationToggle.value = !notificationToggle.value;

    // persist the user's choice
    StorageService.setNotificationsEnabled(notificationToggle.value);

    if (notificationToggle.value) {
      _subscribeToSocket();
      // fetch unread notifications immediately so badge updates
      loadNotifications();
    } else {
      _unsubscribeFromSocket();
      // clear list when disabled
      notifications.clear();
    }
  }

  @override
  void onClose() {
    _notifSub?.cancel();
    SocketService().disconnect();
    super.onClose();
  }
}
