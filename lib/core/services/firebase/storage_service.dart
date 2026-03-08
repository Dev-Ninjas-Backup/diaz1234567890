import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';
  static const String _notificationsEnabledKey = 'notifications_enabled';

  static SharedPreferences? preferences;

  // Start an asynchronous initialization as soon as this class is loaded.
  // This reduces races where other parts of the app read the service
  // before `init()` has been awaited elsewhere (for example on app start).
  // The initializer runs in background; explicit calls to `init()` still
  // await completion.
  static final Future<void> _autoInit = _startInit();

  static Future<void> _startInit() async {
    try {
      preferences ??= await SharedPreferences.getInstance();
    } catch (_) {
      // ignore errors here; explicit init() will try again when needed
    }
  }

  static Future<void> init() async {
    // Ensure the background init has completed, and if preferences is still
    // null try to get an instance explicitly.
    await _autoInit;
    preferences ??= await SharedPreferences.getInstance();
  }

  // Safe way to check if initialized (without accessing private field directly)
  static bool get isInitialized => preferences != null;

  static bool hasToken() {
    // If preferences isn't ready yet, treat as no token. The class attempts
    // to auto-initialize on load; callers that need a guaranteed result should
    // call `await StorageService.init()` during app startup.
    final token = preferences?.getString(_tokenKey);
    return token != null;
  }

  static Future<void> saveToken(String token, String id) async {
    // Ensure preferences is available before attempting to save. This will
    // run the auto-init if still pending and then obtain an instance.
    if (preferences == null) {
      await init();
    }
    await preferences?.setString(_tokenKey, token);
    await preferences?.setString(_idKey, id);
  }

  static Future<void> logoutUser() async {
    if (preferences == null) {
      await init();
    }
    await preferences?.remove(_tokenKey);
    await preferences?.remove(_idKey);
  }

  /// Persist whether the user wants in-app (socket) notifications enabled.
  static Future<void> setNotificationsEnabled(bool enabled) async {
    if (preferences == null) await init();
    await preferences?.setBool(_notificationsEnabledKey, enabled);
  }

  /// Read persisted notification preference. Defaults to `false` if unset.
  static bool get notificationsEnabled =>
      preferences?.getBool(_notificationsEnabledKey) ?? false;

  static String? get userId => preferences?.getString(_idKey);

  static String? get token => preferences?.getString(_tokenKey);

  /// Returns the initial route for the app depending on whether a token is
  /// present. This keeps the auth/startup decision centralized in the
  /// storage service where token state is managed.
}
