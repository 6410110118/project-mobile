import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  // Save access token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Retrieve access token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Delete access token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Retrieve refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Delete refresh token
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }
}
