import 'dart:async';
import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:flutter/foundation.dart';

/// A lightweight socket.io client used to receive realtime notifications
/// while the app is active. This service exposes a stream of incoming
/// notification payloads and handles connecting / disconnecting.
class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;
  final StreamController<Map<String, dynamic>> _notifController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get notifications => _notifController.stream;

  bool get isConnected => _socket != null && _socket!.connected;

  Future<void> connect() async {
    try {
      if (isConnected) return;

      // Ensure token is available for auth headers
      if (!StorageService.isInitialized) {
        await StorageService.init();
      }

      final token = StorageService.token;

      // Build options for socket.io client
      final opts = <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      };

      if (token != null && token.isNotEmpty) {
        opts['extraHeaders'] = {'Authorization': 'Bearer $token'};
      }

      // Socket server typically runs on the base domain, not /api endpoint
      final uri = Endpoints.baseUrl;

      if (kDebugMode) print('SocketService: connecting to $uri');

      _socket = IO.io(uri, opts);

      _socket!.on('connect', (_) {
        if (kDebugMode) print('SocketService: connected');
      });

      _socket!.on('disconnect', (_) {
        if (kDebugMode) print('SocketService: disconnected');
      });

      // Common event name for incoming notifications. Server may use a
      // different event name; adapt if needed.
      _socket!.on('notification', (data) {
        try {
          if (data is Map) {
            _notifController.add(Map<String, dynamic>.from(data));
          } else if (data is String) {
            // attempt to decode JSON string
            final parsed = jsonDecode(data);
            if (parsed is Map)
              _notifController.add(Map<String, dynamic>.from(parsed));
          }
        } catch (e) {
          if (kDebugMode)
            print('SocketService: failed to parse notification: $e');
        }
      });

      _socket!.connect();
    } catch (e) {
      if (kDebugMode) print('SocketService connect error: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      _socket?.disconnect();
      _socket?.destroy();
      _socket = null;
    } catch (e) {
      if (kDebugMode) print('SocketService disconnect error: $e');
    }
  }

  void dispose() {
    _notifController.close();
    disconnect();
  }
}
