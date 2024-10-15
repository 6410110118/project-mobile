import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/dio_client.dart';
import 'package:frontend/services/token_storage.dart';

class ProfileRepository {
  final Dio dio = DioClient.createDio();
  final TokenStorage tokenStorage = TokenStorage();

  Future<UserModel> fetchProfile() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dio.get(
        '/users/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      throw Exception('Failed to fetch user data: $e');
    }
  }

  Future<void> updateUser({
    required String email,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.put(
        '/users/update',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ), // เปลี่ยนเป็น URL ของ API ที่ถูกต้อง
        data: {
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'role': role,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e'); // แสดงข้อผิดพลาด
      // คืนค่า false หากเกิดข้อผิดพลาด
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.put(
        '/users/change_password',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
      } else {
        print('Password changed successfully');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  Future<void> uploadImage(Uint8List imageData) async {
    try {
      final token = await tokenStorage.getToken(); // ใช้ read แทน getToken()

      // สร้าง FormData สำหรับการอัปโหลด
      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          imageData,
          filename: 'profile_image.jpg', // เพิ่มชื่อไฟล์
        ),
      });

      final response = await dio.put(
        '/users/imageProfile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // ไม่ต้องตั้ง Content-Type เป็น multipart/form-data
          },
        ),
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: ${response.data}');
      } else {
        print('Image uploaded successfully');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
