import 'package:dio/dio.dart';
import 'package:frontend/bloc/people/people_state.dart';
import 'package:frontend/models/groups.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/dio_client.dart';
import 'package:frontend/services/token_storage.dart';

class PeopleRepository {
  final Dio dio = DioClient.createDio(); // เรียกใช้ DioClient
  final TokenStorage tokenStorage = TokenStorage();

  Future<int?> getPeopleIdByUsername(String username) async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.get('/users/',
          queryParameters: {'username': username},
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.message}');
      }
      throw Exception('Failed to fetch people: $e');
    }
    return null; // คืนค่า null หากไม่พบ
  }

  Future<List<Group>> fetchGroup() async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.get(
        '/groups/people_id/',
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
          final List<dynamic> groupsJson = response.data['people_group_links'] ?? [];
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
      if (e is PeopleError) {
        print('DioError: ${e.message}');
      }
      throw Exception('Failed to fetch group: $e');
    }
  }
}
