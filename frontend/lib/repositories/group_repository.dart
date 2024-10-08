import 'package:dio/dio.dart';
import 'package:frontend/models/groups.dart';
import 'package:frontend/services/dio_client.dart';
import '../services/token_storage.dart';

class GroupRepository {
  final Dio dio = DioClient.createDio(); // เรียกใช้ DioClient
  final TokenStorage tokenStorage = TokenStorage();

  Future<List<Group>> fetchGroups() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dio.get(
        '/groups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');

        if (response.data is Map<String, dynamic>) {
          final List<dynamic> groupsJson = response.data['groups'];
          return groupsJson
              .map((groupJson) => Group.fromJson(groupJson))
              .toList();
        } else if (response.data is List<dynamic>) {
          return (response.data as List<dynamic>)
              .map((groupJson) => Group.fromJson(groupJson))
              .toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch groups: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to fetch groups: $e');
    }
  }
}
