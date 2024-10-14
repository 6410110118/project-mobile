import 'package:dio/dio.dart';
import 'package:frontend/models/itempeople.dart';
import 'package:frontend/services/dio_client.dart';
import '../services/token_storage.dart';

class ItemPeopleRepository {
  final Dio dio = DioClient.createDio();
  final TokenStorage tokenStorage = TokenStorage();

  Future<List<ItemPeople>> fetchItemPeople() async {
    try {
      final token = await tokenStorage.getToken();

      final response = await dio.get(
        '/item_people',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List<dynamic>) {
          return (response.data as List<dynamic>)
              .map((itemPeopleJson) => ItemPeople.fromJson(itemPeopleJson))
              .toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch item people: ${response.data}');
      }
    } catch (e) {
      throw Exception('Failed to fetch item people: $e');
    }
  }
}
