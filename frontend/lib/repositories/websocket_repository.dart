import 'package:dio/dio.dart';
import 'package:frontend/services/dio_client.dart';
import 'package:frontend/services/token_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketRepository {
  final WebSocketChannel channel;
  final Dio dio = DioClient.createDio();
  final TokenStorage tokenStorage = TokenStorage();

  WebSocketRepository(int groupId, String token)
      : channel = WebSocketChannel.connect(
          Uri.parse(
              'ws://10.0.2.2:8000/groups/ws/groups/$groupId/messages/?token=$token'),
        );

  Stream<dynamic> get messages => channel.stream;

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  Future<void> sendMessageToApi(
      String content, DateTime? startDate, int groupId) async {
    try {
      final token = await tokenStorage.getToken();
      final messageData = {
        'content': content,
        'created_at':
            startDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };
      final response = await dio.post(
        '/groups/messages/$groupId/',
        data: messageData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final sentMessage = response.data['content'];
        sendMessage(sentMessage); 
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print("Error sending message: $e");
      throw Exception('Error sending message');
    }
  }

  void dispose() {
    channel.sink.close();
  }
}
