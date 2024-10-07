import 'package:dio/dio.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/dio_client.dart';
import 'package:frontend/services/token_storage.dart';

class ProfileRepository {
  final Dio dio = DioClient.createDio(); // เรียกใช้ DioClient
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
        
        // ตรวจสอบว่าข้อมูลเป็น List หรือ Map
      }else {
        throw Exception('Failed to fetch user data');
      }
    }catch(e){
      throw Exception('Failed to fetch user data: $e');
    }
  }
}