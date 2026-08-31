import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the mobile companion's session locally: which store it's paired
/// to, the device's own id, and the current signed-in user's token. Nothing
/// here is sensitive enough to need secure storage -- the session token is
/// short-lived and scoped to read-only dashboard access.
class SessionStore {
  SessionStore._();

  static const _kStoreId = 'store_id';
  static const _kDeviceId = 'device_id';
  static const _kSessionToken = 'session_token';
  static const _kExpiresAtMs = 'session_expires_at_ms';
  static const _kUserId = 'user_id';
  static const _kUsername = 'username';
  static const _kFullName = 'full_name';
  static const _kRole = 'role';

  static Future<String> deviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_kDeviceId);
    if (id == null) {
      final rand = Random.secure();
      id = List.generate(16, (_) => rand.nextInt(16).toRadixString(16)).join();
      await prefs.setString(_kDeviceId, id);
    }
    return id;
  }

  static Future<String?> storeId() async =>
      (await SharedPreferences.getInstance()).getString(_kStoreId);

  static Future<void> setStoreId(String storeId) async =>
      (await SharedPreferences.getInstance()).setString(_kStoreId, storeId);

  static Future<Session?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kSessionToken);
    final expiresAtMs = prefs.getInt(_kExpiresAtMs);
    final username = prefs.getString(_kUsername);
    if (token == null || expiresAtMs == null || username == null) return null;

    return Session(
      token: token,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(expiresAtMs),
      userId: prefs.getString(_kUserId) ?? '',
      username: username,
      fullName: prefs.getString(_kFullName) ?? username,
      role: prefs.getString(_kRole) ?? '',
    );
  }

  static Future<void> saveSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSessionToken, session.token);
    await prefs.setInt(_kExpiresAtMs, session.expiresAt.millisecondsSinceEpoch);
    await prefs.setString(_kUserId, session.userId);
    await prefs.setString(_kUsername, session.username);
    await prefs.setString(_kFullName, session.fullName);
    await prefs.setString(_kRole, session.role);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSessionToken);
    await prefs.remove(_kExpiresAtMs);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUsername);
    await prefs.remove(_kFullName);
    await prefs.remove(_kRole);
  }
}

class Session {
  final String token;
  final DateTime expiresAt;
  final String userId;
  final String username;
  final String fullName;
  final String role;

  const Session({
    required this.token,
    required this.expiresAt,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
