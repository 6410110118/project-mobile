import 'package:dio/dio.dart';
import 'package:frontend/services/dio_client.dart';
import '../services/token_storage.dart';

class UserRepository {
  final Dio dio = DioClient.createDio(); // Create DioClient instance
  final TokenStorage tokenStorage = TokenStorage();

  Future<void> register({
    required String email,
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    required String role,
    required String confirmPassword,
  }) async {
    final String endpoint = role == 'Leader'
        ? '/users/register_leader'
        : '/users/register_people';

    try {
      // Retrieve the token
      final token = await tokenStorage.getToken();

      // Prepare the data with user_info
      final Map<String, dynamic> data = {
        'user_info': {
          'email': email,
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
        },
      };

      // Add leader_info if the role is Leader
      if (role == 'Leader') {
        data['leader_info'] = {
          'firstname': firstName,
          'lastname': lastName,
        };
      }else{
        data['people_info'] = {
          'firstname': firstName,
          'lastname': lastName,
        };
      }

      // Print data for debugging
      print('Data being sent: $data');

      // Send the registration request
      final response = await dio.post(
        endpoint,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Registration failed');
      }
    } catch (error) {
      throw Exception('Failed to register: $error');
    }
  }
}
