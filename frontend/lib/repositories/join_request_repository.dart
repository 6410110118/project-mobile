import 'package:dio/dio.dart';
import 'package:frontend/models/joinrequest.dart';
import 'package:frontend/services/dio_client.dart';
import '../services/token_storage.dart';

class JoinRequestRepository {
  final Dio dio = DioClient.createDio();
  final TokenStorage tokenStorage = TokenStorage();

  Future<List<JoinRequest>> fetchJoinRequests() async {
    try {
      final token = await tokenStorage.getToken();
      final requestUrl = '/items/join_requests';
      print('Making request to: ${dio.options.baseUrl}$requestUrl');
      print('Using token: $token');

      final response = await dio.get(
        requestUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Join requests fetched successfully: ${response.data}');
        return (response.data as List)
            .map((json) => JoinRequest.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to fetch join requests: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error fetching join requests: $e');
      rethrow;
    }
  }

  Future<void> respondToJoinRequest(
      int itemId, int joinRequestId, bool isApproved) async {
    try {
      final requestUrl = '/items/$itemId/join/$joinRequestId';
      print('Making PUT request to: ${dio.options.baseUrl}$requestUrl');
      
      final response = await dio.put(
        requestUrl,
        data: {
          'is_approved': isApproved  // ส่งค่า is_approved ใน request body
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await tokenStorage.getToken()}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Join request responded successfully');
      } else {
        throw Exception(
            'Failed to respond to join request: ${response.statusCode} ${response.data}');
      }
    } catch (e) {
      print('Error responding to join request: $e');
      rethrow;
    }
  }
}
