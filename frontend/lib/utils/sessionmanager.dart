import 'dart:async';
import 'package:frontend/screens/widgets/token_expiry_dialogue.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _tokenKey = "auth_token";
  static Timer? _expiryTimer;

  /// Save token & start expiry watcher
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    _startExpiryWatcher(token);
  }

  /// Returns true if a valid, non-expired token exists
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  /// Get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Clear token & stop watcher
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);

    _expiryTimer?.cancel();
    _expiryTimer = null;
  }

  /// Check if token is expired
  static Future<bool> isTokenExpired() async {
    final token = await getToken();
    if (token == null) return true;
    return JwtDecoder.isExpired(token);
  }

  /// Internal: starts one-shot timer until token expiry
  static void _startExpiryWatcher(String token) {
    _expiryTimer?.cancel(); // cancel old timer if any

    if (JwtDecoder.isExpired(token)) {
      _forceLogoutDueToExpiry();
      return;
    }

    final expiryDate = JwtDecoder.getExpirationDate(token);
    final now = DateTime.now();
    final secondsUntilExpiry = expiryDate.difference(now).inSeconds;

    if (secondsUntilExpiry > 0) {
      _expiryTimer = Timer(Duration(seconds: secondsUntilExpiry), () {
        _forceLogoutDueToExpiry();
      });
    } else {
      _forceLogoutDueToExpiry();
    }
  }

  /// Logout flow when token expires
  static Future<void> _forceLogoutDueToExpiry() async {
    showTokenExpiryDialogue();
  }

  /// Call this once at app startup to restore watcher
  static Future<void> init() async {
    final token = await getToken();
    if (token != null) {
      _startExpiryWatcher(token);
    }
  }
}
