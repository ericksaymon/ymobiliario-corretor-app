import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/app_models.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager instance = SessionManager._();
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'user_json';

  String? _accessToken;
  String? _refreshToken;
  AppUser? _user;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  AppUser? get user => _user;

  Future<void> load() async {
    _accessToken = await _storage.read(key: _accessTokenKey);
    _refreshToken = await _storage.read(key: _refreshTokenKey);
    final rawUser = await _storage.read(key: _userKey);
    if (rawUser != null && rawUser.isNotEmpty) {
      _user = AppUser.fromJson(jsonDecode(rawUser) as Map<String, dynamic>);
    }
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required AppUser user,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _user = user;
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<void> updateAccessToken(String token) async {
    _accessToken = token;
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<void> updateUser(AppUser user) async {
    _user = user;
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    _user = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userKey);
  }
}
