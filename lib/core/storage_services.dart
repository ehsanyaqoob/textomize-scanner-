import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // -------------------- Onboarding --------------------
  static Future<void> setOnboardingSeen(bool seen) async {
    await _prefs.setBool('onboarding_seen', seen);
  }

  static bool hasSeenOnboarding() {
    return _prefs.getBool('onboarding_seen') ?? false;
  }

  // -------------------- Login / Signup --------------------
 static Future<void> setLoggedIn(bool value) async {
  await _prefs.setBool('is_logged_in', value);
}

static bool isLoggedIn() {
  return _prefs.getBool('is_logged_in') ?? false;  // Default to false if not set
}

  static Future<void> saveUserToken(String token) async {
    await _prefs.setString('user_token', token);
  }

  static String? getUserToken() {
    return _prefs.getString('user_token');
  }

  static Future<void> saveUserName(String name) async {
    await _prefs.setString('user_name', name);
  }

  static String? getUserName() {
    return _prefs.getString('user_name');
  }

  static Future<void> saveUserEmail(String email) async {
    await _prefs.setString('user_email', email);
  }

  static String? getUserEmail() {
    return _prefs.getString('user_email');
  }

  static Future<void> savePhoneNumber(String phone) async {
    await _prefs.setString('user_phone', phone);
  }

  static String? getPhoneNumber() {
    return _prefs.getString('user_phone');
  }

  static Future<void> saveUserId(String id) async {
    await _prefs.setString('user_id', id);
  }

  static String? getUserId() {
    return _prefs.getString('user_id');
  }

  // -------------------- Generic Set/Get --------------------
  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // -------------------- Logout / Clear All --------------------
  static Future<void> logOut() async {
    await _prefs.clear(); // Clear all preferences on logout
  }
}
