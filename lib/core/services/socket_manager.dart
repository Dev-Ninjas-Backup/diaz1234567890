import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:diaz1234567890/core/services/socket_service.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';

/// Global socket manager that handles connections based on notification toggle
class SocketManager extends GetxController {
  static final SocketManager _instance = SocketManager._internal();

  factory SocketManager() {
    return _instance;
  }

  SocketManager._internal();

  final notificationsEnabled = false.obs;
  final socketConnected = false.obs;
  bool _isConnecting = false;

  @override
  void onInit() {
    super.onInit();
    // Initialize async without blocking - setup and monitoring are called from _initializeNotificationPreference
    _initializeNotificationPreference();
  }

  Future<void> _initializeNotificationPreference() async {
    // Read persisted preference from StorageService
    notificationsEnabled.value = StorageService.notificationsEnabled;

    if (kDebugMode) {
      print(
        'SocketManager: Notifications preference loaded: ${notificationsEnabled.value}',
      );
    }

    // If notifications are enabled, connect immediately
    if (notificationsEnabled.value) {
      await _connectSocket();
      // Give socket time to establish connection
      await Future.delayed(const Duration(milliseconds: 500));
      // Print initial status after socket connection settles
      _printSocketStatus();
    }

    // Now setup the listener and monitoring
    _setupToggleListener();
    _monitorSocketStatus();
  }

  void _printSocketStatus() {
    final isConnected = SocketService().isConnected;
    if (kDebugMode) {
      print(
        'SocketManager: Socket Status → ${isConnected ? 'CONNECTED' : 'DISCONNECTED'}',
      );
    }
    socketConnected.value = isConnected;
  }

  void _setupToggleListener() {
    // Listen to toggle changes
    ever(notificationsEnabled, (bool enabled) {
      if (kDebugMode) {
        print('SocketManager: Notifications toggle changed to: $enabled');
      }

      if (enabled) {
        _connectSocket();
      } else {
        _disconnectSocket();
      }
    });
  }

  void _monitorSocketStatus() {
    // Start immediate monitoring loop - check immediately and every 300ms
    _checkAndPrintSocketStatus();
  }

  void _checkAndPrintSocketStatus() {
    final isConnected = SocketService().isConnected;

    // If status changed, print it
    if (isConnected != socketConnected.value) {
      socketConnected.value = isConnected;
      if (kDebugMode) {
        print('═══════════════════════════════════════════');
        print(
          'SocketManager: Socket Status → ${isConnected ? 'CONNECTED ✓' : 'DISCONNECTED ✗'}',
        );
        print('═══════════════════════════════════════════');
      }
    }

    // Continue monitoring every 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      if (Get.isRegistered<SocketManager>()) {
        _checkAndPrintSocketStatus();
      }
    });
  }

  Future<void> _connectSocket() async {
    if (_isConnecting) return;
    if (SocketService().isConnected) return;

    _isConnecting = true;
    try {
      if (kDebugMode) {
        print('SocketManager: Attempting to connect socket...');
      }
      await SocketService().connect();
      if (kDebugMode) {
        print('SocketManager: Socket connect initiated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('SocketManager: Error connecting socket: $e');
      }
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> _disconnectSocket() async {
    try {
      if (kDebugMode) {
        print('SocketManager: Disconnecting socket...');
      }
      await SocketService().disconnect();
      if (kDebugMode) {
        print('SocketManager: Socket disconnected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('SocketManager: Error disconnecting socket: $e');
      }
    }
  }

  /// Call this when user toggles notifications in settings
  Future<void> toggleNotifications(bool enabled) async {
    notificationsEnabled.value = enabled;
    // Save to persistent storage
    await StorageService.setNotificationsEnabled(enabled);
  }

  @override
  void onClose() {
    _disconnectSocket();
    super.onClose();
  }
}
