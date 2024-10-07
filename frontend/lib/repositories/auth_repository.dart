import 'package:dio/dio.dart';
import '../services/dio_client.dart';
import '../services/token_storage.dart';

class AuthRepository {
  final Dio dio = DioClient.createDio(); // เรียกใช้ DioClient
  final TokenStorage tokenStorage = TokenStorage();

  Future<String> login(String username, String password) async {
    try {
      final response = await dio.post(
        '/token',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded', // กำหนด Content-Type
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

        // บันทึกทั้ง access token และ refresh token
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
            'Content-Type': 'application/x-www-form-urlencoded', // กำหนด Content-Type
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
    await tokenStorage.deleteRefreshToken(); // ลบ refresh token ด้วย
    // Add any additional logout logic here
  }
   Future<void> changePassword(String currentPassword, String newPassword) async {
    try{
      final response = await dio.put(
        '/users/change_password',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password: ${response.data}');
      }else{
        print('Password changed successfully');
      }
    }catch(e){
      throw Exception('Failed to change password: $e');
    }
   }  
}
