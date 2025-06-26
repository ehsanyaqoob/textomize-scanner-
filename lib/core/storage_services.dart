import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'exports.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // -------------------- Keys --------------------
  static const _firstLaunchKey = 'is_first_launch';
  static const _onboardingSeenKey = 'onboarding_seen';
  static const _loggedInKey = 'is_logged_in';
  static const _profileImageKey = 'user_profile_image_path';
  static const _tokenKey = 'user_token';
  static const _nameKey = 'user_name';
  static const _emailKey = 'user_email';
  static const _userIdKey = 'user_id';
  static const _phoneKey = 'user_phone';
  static const _lastLoginKey = 'last_login_timestamp';

  // -------------------- Initialization --------------------
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    debugPrint('✅ StorageService initialized');
  }

  // -------------------- First Launch --------------------
  static Future<bool> getFirstLaunchStatus() async {
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchStatus(bool value) async {
    await _prefs.setBool(_firstLaunchKey, value);
    debugPrint('First launch status set to: $value');
  }

  // -------------------- Onboarding --------------------
  static Future<void> setOnboardingSeen(bool seen) async {
    await _prefs.setBool(_onboardingSeenKey, seen);
    debugPrint('Onboarding seen status set to: $seen');
  }

  static bool hasSeenOnboarding() {
    return _prefs.getBool(_onboardingSeenKey) ?? false;
  }

  // -------------------- Authentication Status --------------------
  static Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_loggedInKey, value);
    if (value) {
      await _prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
    }
    debugPrint('🔐 Logged in status set to: $value');
  }

  static bool isLoggedIn() {
    return _prefs.getBool(_loggedInKey) ?? false;
  }

  // -------------------- User Profile Image --------------------
  static Future<void> saveUserProfileImagePath(String path) async {
    await _prefs.setString(_profileImageKey, path.trim());
    debugPrint('🖼️ Profile image path saved: $path');
  }

  static String? getUserProfileImagePath() {
    return _prefs.getString(_profileImageKey);
  }

  static Future<void> removeUserProfileImagePath() async {
    await _prefs.remove(_profileImageKey);
    debugPrint('🧹 Profile image path removed');
  }

  // -------------------- User Token --------------------
  static Future<void> saveUserToken(String token) async {
    await _prefs.setString(_tokenKey, token.trim());
    debugPrint('🔑 User token saved');
  }

  static String? getUserToken() {
    return _prefs.getString(_tokenKey);
  }

  // -------------------- User Details --------------------
  static Future<void> saveUserDetails({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? profileImage,
    String? token,
  }) async {
    debugPrint('📦 Saving user details...');
    debugPrint('   ID: $id');
    debugPrint('   Name: "$name"');
    debugPrint('   Email: $email');

    await Future.wait([
      saveUserId(id),
      saveUserName(name),
      saveUserEmail(email),
      if (phone != null && phone.trim().isNotEmpty) savePhoneNumber(phone),
      if (profileImage != null && profileImage.trim().isNotEmpty)
        saveUserProfileImagePath(profileImage),
      if (token != null && token.trim().isNotEmpty) saveUserToken(token),
    ]);

    debugPrint('✅ User details saved for: $email');
  }

  static Future<void> saveUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      debugPrint('🚫 User name not saved: value is empty');
      return;
    }
    await _prefs.setString(_nameKey, trimmed);
    debugPrint('👤 User name saved: $trimmed');
  }

  static String? getUserName() {
    final name = _prefs.getString(_nameKey);
    return (name != null && name.trim().isNotEmpty) ? name : null;
  }

  static Future<void> saveUserEmail(String email) async {
    await _prefs.setString(_emailKey, email.trim());
    debugPrint('📧 User email saved: $email');
  }

  static String? getUserEmail() {
    return _prefs.getString(_emailKey);
  }

  static Future<void> saveUserId(String id) async {
    await _prefs.setString(_userIdKey, id.trim());
    debugPrint('🆔 User ID saved: $id');
  }

  static String? getUserId() {
    return _prefs.getString(_userIdKey);
  }

  static Future<void> savePhoneNumber(String phone) async {
    await _prefs.setString(_phoneKey, phone.trim());
    debugPrint('📱 Phone number saved: $phone');
  }

  static String? getPhoneNumber() {
    return _prefs.getString(_phoneKey);
  }

  // -------------------- User Session Management --------------------
  static Future<void> clearSession() async {
    await Future.wait([
      _prefs.remove(_loggedInKey),
      _prefs.remove(_tokenKey),
      _prefs.remove(_nameKey),
      _prefs.remove(_emailKey),
      _prefs.remove(_profileImageKey),
      _prefs.remove(_userIdKey),
      _prefs.remove(_phoneKey),
    ]);
    debugPrint('🚫 User session cleared');
  }

  static Future<void> logOut() async {
    await clearSession();
    debugPrint('🚪 User logged out');
  }

  // -------------------- Last Login Timestamp --------------------
  static DateTime? getLastLogin() {
    final timestamp = _prefs.getInt(_lastLoginKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // -------------------- Generic Methods --------------------
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

  // -------------------- User Data Bundle --------------------
  static Map<String, dynamic>? getUserData() {
    if (!isLoggedIn()) return null;

    return {
      'id': getUserId(),
      'name': getUserName(),
      'email': getUserEmail(),
      'phone': getPhoneNumber(),
      'profileImage': getUserProfileImagePath(),
      'token': getUserToken(),
      'lastLogin': getLastLogin(),
    };
  }

  // -------------------- Debug Helper --------------------
  static void printAllStoredData() {
    debugPrint('--- 📦 Storage Contents ---');
    for (var key in _prefs.getKeys()) {
      debugPrint('$key: ${_prefs.get(key)}');
    }
    debugPrint('---------------------------');
  }

  // -------------------- Placeholders --------------------
  static void saveUserRole(dynamic userRole) {
    // You can implement this when needed
  }

  static void saveUserPhone(dynamic userPhone) {
    // You can implement this when needed
  }
}
