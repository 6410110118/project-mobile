import 'package:dio/dio.dart';
import 'package:frontend/models/groups.dart';
import 'package:frontend/models/person.dart';
import 'package:frontend/services/dio_client.dart';
import '../services/token_storage.dart';

class GroupRepository {
  final Dio dio = DioClient.createDio(); // เรียกใช้ DioClient
  final TokenStorage tokenStorage = TokenStorage();

  // ฟังก์ชันดึงข้อมูลกลุ่มที่มีอยู่
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
          final List<dynamic> groupsJson = response.data['groups'] ?? [];
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

  // ฟังก์ชันสำหรับสร้างกลุ่มใหม่

  Future<void> createGroup({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final token = await tokenStorage.getToken();

      // สร้างข้อมูลกลุ่มในรูปแบบ Map
      final groupData = {
        'name': name,
        'start_date':
            startDate?.toIso8601String(), // แปลง DateTime เป็น ISO 8601 String
        'end_date':
            endDate?.toIso8601String() // แปลง DateTime เป็น ISO 8601 String
      };

      final response = await dio.post(
        '/groups',
        data: groupData, // ส่งข้อมูลกลุ่มในรูปแบบ Map
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // เปลี่ยนเป็น 201 สำหรับการสร้างที่สำเร็จ
        print('Group Created successfully: ${response.data}');
      } else {
        throw Exception('Failed to create group: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  Future<void> addPersonToGroup(int groupId, int userId) async {
    try {
      print('Group ID: $groupId, User ID: $userId'); // พิมพ์ค่า ID
      final token = await tokenStorage.getToken();
      final response = await dio.put(
        '/groups/add_people_to_group/$groupId/$userId/', // ใช้ userId แทน peopleId
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('User added to group successfully');
      } else {
        throw Exception('Failed to add user to group: ${response.data}');
      }
    } catch (e) {
      print(e); // พิมพ์ข้อผิดพลาด
      throw Exception('Failed to add user to group: $e');
    }
  }

  Future<List<Person>> getPeopleInGroup(int groupId) async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.get(
        '/groups/$groupId/people',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');

        if (response.data is List<dynamic>) {
          return (response.data as List<dynamic>)
              .map((personJson) => Person.fromJson(personJson))
              .toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch people: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load people: $e');
    }
  }

}
