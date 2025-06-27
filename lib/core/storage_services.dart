import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textomize/core/exports.dart';

class StorageService {
  static SharedPreferences? _prefs;

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
  static const _roleKey = 'user_role';

  // -------------------- Initialization --------------------
  static Future<void> ensureInitialized() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('✅ StorageService initialized');
    }
  }

  // -------------------- First Launch --------------------
  static Future<bool> getFirstLaunchStatus() async {
    await ensureInitialized();
    return _prefs!.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchStatus(bool value) async {
    await ensureInitialized();
    await _prefs!.setBool(_firstLaunchKey, value);
    debugPrint('First launch status set to: $value');
  }

  // -------------------- Onboarding --------------------
  static Future<void> setOnboardingSeen(bool seen) async {
    await ensureInitialized();
    await _prefs!.setBool(_onboardingSeenKey, seen);
    debugPrint('Onboarding seen status set to: $seen');
  }

  static Future<bool> hasSeenOnboarding() async {
    await ensureInitialized();
    return _prefs!.getBool(_onboardingSeenKey) ?? false;
  }

  // -------------------- Authentication Status --------------------
  static Future<void> setLoggedIn(bool value) async {
    await ensureInitialized();
    await _prefs!.setBool(_loggedInKey, value);
    if (value) {
      await _prefs!.setInt(
          _lastLoginKey, DateTime.now().millisecondsSinceEpoch);
    }
    debugPrint('🔐 Logged in status set to: $value');
  }

  static Future<bool> isLoggedIn() async {
    await ensureInitialized();
    return _prefs!.getBool(_loggedInKey) ?? false;
  }

  // -------------------- User Profile Image --------------------
  static Future<void> saveUserProfileImagePath(String path) async {
    await ensureInitialized();
    await _prefs!.setString(_profileImageKey, path.trim());
    debugPrint('🖼️ Profile image path saved: $path');
  }

  static Future<String?> getUserProfileImagePath() async {
    await ensureInitialized();
    return _prefs!.getString(_profileImageKey);
  }

  static Future<void> removeUserProfileImagePath() async {
    await ensureInitialized();
    await _prefs!.remove(_profileImageKey);
    debugPrint('🧹 Profile image path removed');
  }

  // -------------------- User Token --------------------
  static Future<void> saveUserToken(String token) async {
    await ensureInitialized();
    await _prefs!.setString(_tokenKey, token.trim());
    debugPrint('🔑 User token saved');
  }

  static Future<String?> getUserToken() async {
    await ensureInitialized();
    return _prefs!.getString(_tokenKey);
  }

  // -------------------- User Details --------------------
  static Future<void> saveUserDetails({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? profileImage,
    String? token,
    String? role,
  }) async {
    debugPrint('📦 Saving user details...');
    debugPrint('   ID: $id');
    debugPrint('   Name: "$name"');
    debugPrint('   Email: $email');

    await ensureInitialized();
    
    try {
      await Future.wait([
        saveUserId(id),
        saveUserName(name),
        saveUserEmail(email),
        if (phone != null && phone.trim().isNotEmpty) savePhoneNumber(phone),
        if (profileImage != null && profileImage.trim().isNotEmpty)
          saveUserProfileImagePath(profileImage),
        if (token != null && token.trim().isNotEmpty) saveUserToken(token),
        if (role != null && role.trim().isNotEmpty) saveUserRole(role),
      ]);

      debugPrint('✅ User details saved for: $email');
    } catch (e) {
      debugPrint('❌ Error saving user details: $e');
      rethrow;
    }
  }

  static Future<void> saveUserName(String name) async {
    await ensureInitialized();
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      debugPrint('🚫 User name not saved: value is empty');
      return;
    }
    await _prefs!.setString(_nameKey, trimmed);
    debugPrint('👤 User name saved: $trimmed');
  }

  static Future<String?> getUserName() async {
    await ensureInitialized();
    final name = _prefs!.getString(_nameKey);
    return (name != null && name.trim().isNotEmpty) ? name : null;
  }

  static Future<void> saveUserEmail(String email) async {
    await ensureInitialized();
    await _prefs!.setString(_emailKey, email.trim());
    debugPrint('📧 User email saved: $email');
  }

  static Future<String?> getUserEmail() async {
    await ensureInitialized();
    return _prefs!.getString(_emailKey);
  }

  static Future<void> saveUserId(String id) async {
    await ensureInitialized();
    await _prefs!.setString(_userIdKey, id.trim());
    debugPrint('🆔 User ID saved: $id');
  }

  static Future<String?> getUserId() async {
    await ensureInitialized();
    return _prefs!.getString(_userIdKey);
  }

  static Future<void> savePhoneNumber(String phone) async {
    await ensureInitialized();
    await _prefs!.setString(_phoneKey, phone.trim());
    debugPrint('📱 Phone number saved: $phone');
  }

  static Future<String?> getPhoneNumber() async {
    await ensureInitialized();
    return _prefs!.getString(_phoneKey);
  }

  static Future<void> saveUserRole(String role) async {
    await ensureInitialized();
    await _prefs!.setString(_roleKey, role.trim());
    debugPrint('🎭 User role saved: $role');
  }

  static Future<String?> getUserRole() async {
    await ensureInitialized();
    return _prefs!.getString(_roleKey);
  }

  // -------------------- User Session Management --------------------
  static Future<void> clearSession() async {
    await ensureInitialized();
    try {
      await _prefs!.clear();
      debugPrint('🚫 User session cleared');
    } catch (e) {
      debugPrint('❌ Error clearing session: $e');
      rethrow;
    }
  }

  static Future<void> logOut() async {
    await clearSession();
    debugPrint('🚪 User logged out');
  }

  // -------------------- Last Login Timestamp --------------------
  static Future<DateTime?> getLastLogin() async {
    await ensureInitialized();
    final timestamp = _prefs!.getInt(_lastLoginKey);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  // -------------------- User Data Bundle --------------------
  static Future<Map<String, dynamic>?> getUserData() async {
    await ensureInitialized();
    if (!(await isLoggedIn())) return null;

    return {
      'id': await getUserId(),
      'name': await getUserName(),
      'email': await getUserEmail(),
      'phone': await getPhoneNumber(),
      'profileImage': await getUserProfileImagePath(),
      'token': await getUserToken(),
      'lastLogin': await getLastLogin(),
      'role': await getUserRole(),
    };
  }

  // -------------------- Debug Helper --------------------
  static Future<void> printAllStoredData() async {
    await ensureInitialized();
    debugPrint('--- 📦 Storage Contents ---');
    for (var key in _prefs!.getKeys()) {
      debugPrint('$key: ${_prefs!.get(key)}');
    }
    debugPrint('---------------------------');
  }
}