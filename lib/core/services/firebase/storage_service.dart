import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';

  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences ??= await SharedPreferences.getInstance();
  }

  // Safe way to check if initialized (without accessing private field directly)
  static bool get isInitialized => preferences != null;

  static bool hasToken() {
    final token = preferences?.getString(_tokenKey);
    return token != null;
  }

  static Future<void> saveToken(String token, String id) async {
    await preferences?.setString(_tokenKey, token);
    await preferences?.setString(_idKey, id);
  }

  static Future<void> logoutUser() async {
    await preferences?.remove(_tokenKey);
    await preferences?.remove(_idKey);
  }

  static String? get userId => preferences?.getString(_idKey);

  static String? get token => preferences?.getString(_tokenKey);
}
