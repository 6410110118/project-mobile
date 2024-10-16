import 'package:dio/dio.dart';
import '../services/dio_client.dart';
import '../services/token_storage.dart';

class AuthRepository {
  final Dio dio = DioClient.createDio();
  final TokenStorage tokenStorage = TokenStorage();

  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/token',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['access_token'];
        final refreshToken = response.data['refresh_token'];

        await tokenStorage.saveToken(accessToken);
        await tokenStorage.saveRefreshToken(refreshToken);
        return accessToken;
      } else {
        throw Exception('Failed to login: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<String> refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      final response = await dio.post(
        '/token/refresh',
        options: Options(
          headers: {
            'Content-Type':
                'application/x-www-form-urlencoded', // กำหนด Content-Type
          },
        ),
        data: {
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        await tokenStorage.saveToken(newAccessToken);
        return newAccessToken;
      } else {
        throw Exception('Failed to refresh token: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  Future<void> logout() async {
    await tokenStorage.deleteToken();
    await tokenStorage.deleteRefreshToken();
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      final response = await dio.put(
        '/users/reset-password',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reset password: ${response.data}');
      } else {
        print('Password reset successfully');
      }
    } catch (e) {
      throw Exception('Failed to reset password: $e');
    }
  }
}
