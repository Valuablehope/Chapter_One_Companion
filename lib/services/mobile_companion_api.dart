import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/dashboard_snapshot.dart';
import 'session_store.dart';

const _kConvexSiteUrl = 'https://wonderful-spider-492.eu-west-1.convex.site';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

/// Thrown when the stored session token is missing, expired, or the store's
/// Mobile Companion entitlement has been switched off since login.
class SessionExpiredException extends ApiException {
  const SessionExpiredException() : super('Your session has expired. Please sign in again.');
}

class LoginResult {
  final bool approved;
  final String? errorMessage;
  final Session? session;

  const LoginResult._({required this.approved, this.errorMessage, this.session});
  factory LoginResult.approved(Session session) => LoginResult._(approved: true, session: session);
  factory LoginResult.denied(String message) => LoginResult._(approved: false, errorMessage: message);
}

/// Talks directly to the Convex-hosted mobile companion relay -- never to
/// the desktop machine itself. See cfms/convex/mobileCompanion.ts + http.ts
/// for the server side of every call here.
class MobileCompanionApi {
  MobileCompanionApi._();

  static Future<String> _requestLogin({
    required String storeId,
    required String username,
    required String password,
    required String deviceId,
  }) async {
    final response = await http
        .post(
          Uri.parse('$_kConvexSiteUrl/mobile/login/request'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'storeId': storeId,
            'username': username,
            'password': password,
            'deviceId': deviceId,
            'deviceName': defaultTargetPlatform.name,
          }),
        )
        .timeout(const Duration(seconds: 15));

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['ok'] != true) {
      switch (data['reason']) {
        case 'MOBILE_COMPANION_NOT_ENABLED':
          throw const ApiException(
              'Mobile Companion isn\'t enabled for this store yet. Ask your admin to enable it.');
        case 'INVALID_REQUEST':
          throw const ApiException('Enter a store ID, username, and password.');
        default:
          throw const ApiException('Could not reach the store. Check the Store ID and try again.');
      }
    }

    return data['requestId'] as String;
  }

  static Future<Map<String, dynamic>> _pollStatus(String requestId) async {
    final response = await http
        .get(Uri.parse('$_kConvexSiteUrl/mobile/login/status?requestId=$requestId'))
        .timeout(const Duration(seconds: 15));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Creates a login handshake, then polls until the desktop app (which
  /// alone can check the password) resolves it, or the handshake times out.
  /// [onWaiting] fires once polling starts, so the UI can show "Waiting for
  /// your Chapter One desktop app...".
  static Future<LoginResult> login({
    required String storeId,
    required String username,
    required String password,
    required VoidCallback onWaiting,
  }) async {
    final deviceId = await SessionStore.deviceId();
    final requestId = await _requestLogin(
      storeId: storeId,
      username: username,
      password: password,
      deviceId: deviceId,
    );

    onWaiting();

    final deadline = DateTime.now().add(const Duration(seconds: 30));
    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(seconds: 2));
      final status = await _pollStatus(requestId);

      switch (status['status']) {
        case 'approved':
          final session = Session(
            token: status['sessionToken'] as String,
            // Server issues a 24h token; the exact expiry doesn't matter
            // here since /mobile/dashboard is the real source of truth
            // (a 401 always forces re-login regardless of this estimate).
            expiresAt: DateTime.now().add(const Duration(hours: 24)),
            userId: status['userId'] as String? ?? '',
            username: status['username'] as String? ?? username,
            fullName: status['fullName'] as String? ?? username,
            role: status['role'] as String? ?? '',
          );
          await SessionStore.saveSession(session);
          await SessionStore.setStoreId(storeId);
          return LoginResult.approved(session);
        case 'denied':
          return LoginResult.denied(status['errorMessage'] as String? ?? 'Invalid username or password');
        case 'expired':
        case 'not_found':
          return LoginResult.denied('Login request timed out. Please try again.');
        default:
          continue; // still pending
      }
    }

    return LoginResult.denied('Timed out waiting for the desktop app to respond.');
  }

  static Future<DashboardSnapshot> fetchDashboard(String token) async {
    final response = await http.get(
      Uri.parse('$_kConvexSiteUrl/mobile/dashboard'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 401) {
      await SessionStore.clearSession();
      throw const SessionExpiredException();
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['ok'] != true) {
      throw const ApiException('Could not load dashboard data.');
    }

    final snapshot = data['snapshot'] as Map<String, dynamic>?;
    if (snapshot == null) {
      // Entitled and authenticated, but the desktop hasn't pushed a
      // snapshot yet (e.g. just paired, or the desktop app is offline).
      throw const ApiException(
          'No data yet from the store. Make sure the Chapter One desktop app is running.');
    }

    return DashboardSnapshot.fromJson(snapshot);
  }
}
