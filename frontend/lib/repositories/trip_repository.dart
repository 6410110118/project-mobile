import 'package:dio/dio.dart';
import 'package:frontend/services/dio_client.dart';

import '../models/models.dart';
import '../services/token_storage.dart';

class TripRepository {
  final Dio dio = DioClient.createDio();
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

        if (response.data is Map<String, dynamic>) {
          final List<dynamic> tripsJson = response.data['items'];
          return tripsJson.map((tripJson) => Trip.fromJson(tripJson)).toList();
        } else if (response.data is List<dynamic>) {
          return (response.data as List<dynamic>)
              .map((tripJson) => Trip.fromJson(tripJson))
              .toList();
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

  Future<void> postTrip(Trip trip) async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.post(
        '/items',
        data: trip.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Trip posted successfully: ${response.data}');
      } else {
        throw Exception('Failed to post trip: ${response.data}');
      }
    } catch (e) {
      print('Error while posting trip: $e');
    }
  }

  Future<void> joinTrip(String tripId) async {
    try {
      final token = await tokenStorage.getToken();
      final response = await dio.post(
        '/items/$tripId/join',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Successfully joined trip: ${response.data}');
      } else {
        throw Exception('Failed to join trip: ${response.data}');
      }
    } catch (e) {
      print('Error while joining trip: $e');
      throw Exception('Error while joining trip: $e');
    }
  }
}
