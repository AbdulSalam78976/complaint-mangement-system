import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/resources/routes/routes_names.dart';
import 'package:frontend/screens/resuable%20and%20common%20components/token_expiry_dialogue.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _tokenKey = "auth_token";
  static Timer? _expiryTimer;

  /// Save token & start expiry watcher
  static Future<void> saveToken(String token) async {
    debugPrint("Saving token: $token");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);

    debugPrint("Saved token: ${prefs.getString(_tokenKey)}");

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

  static Future<dynamic> decodeToken() async {
    final token = await getToken();
    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);
      debugPrint("decoded token: $decodedToken");
      return decodedToken;
    }
  }

  /// Call this once at app startup to restore watcher
  static Future<void> init() async {
    final token = await getToken();
    if (token != null) {
      _startExpiryWatcher(token);
    }
  }

  static Future<void> navigateBasedOnRole() async {
    final decoded = await decodeToken();
    final role = decoded?['role'];
    debugPrint(role);
    if (role == 'user') {
      Get.offNamed(RouteName.userDashboard);
    } else if (role == 'admin') {
      Get.offNamed(RouteName.adminDashboard);
    } else {
      Get.offNamed(RouteName.loginScreen);
    }
  }
}
