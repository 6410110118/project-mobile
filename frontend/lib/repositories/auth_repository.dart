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
        final token = response.data['access_token']; // ตรวจสอบคีย์ที่ถูกต้อง
        await tokenStorage.saveToken(token);
        return token;
      } else {
        throw Exception('Failed to login: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    await tokenStorage.deleteToken();
    // Add any additional logout logic here
  }
}
