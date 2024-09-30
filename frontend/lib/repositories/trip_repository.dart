import 'package:dio/dio.dart';
import 'package:frontend/services/dio_client.dart';

import '../models/models.dart';
import '../services/token_storage.dart';

class TripRepository {
  final Dio dio = DioClient.createDio(); // เรียกใช้ DioClient
  final TokenStorage tokenStorage = TokenStorage();

  Future<List<Trip>> fetchTrips() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dio.get(
        '/items-activities',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        
        // ตรวจสอบว่าข้อมูลเป็น List หรือ Map
        if (response.data is Map<String, dynamic>) {
          final List<dynamic> tripsJson = response.data['items']; // ใช้ชื่อคีย์ที่ถูกต้อง
          return tripsJson.map((tripJson) => Trip.fromJson(tripJson)).toList();
        } else if (response.data is List<dynamic>) {
          return (response.data as List<dynamic>).map((tripJson) => Trip.fromJson(tripJson)).toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch trips: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to fetch trips: $e');
    }
  }

}