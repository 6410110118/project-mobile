import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:frontend/repositories/websocket_repository.dart';

import 'message_event.dart';
import 'message_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final WebSocketRepository repository;
  late StreamSubscription<dynamic> _messageSubscription;

  WebSocketBloc(this.repository) : super(WebSocketInitial()) {
    on<ConnectWebSocketEvent>((event, emit) {
      _connect();
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        await repository.sendMessageToApi(
            event.content, DateTime.now() , event.groupId); // ส่งข้อความไปยัง API
      } catch (e) {
        print("Error sending message: $e");
        emit(WebSocketError(e.toString())); // ส่ง State ข้อผิดพลาด
      }
    });

    on<ReceiveMessageEvent>((event, emit) {
      print('Received message: ${event.message}');
      emit(WebSocketMessageReceived(event.message));
    });
    
  }

  void _connect() {
    _messageSubscription = repository.messages.listen((message) {
      add(ReceiveMessageEvent(message.toString()));
    });
  }

  @override
  Future<void> close() {
    _messageSubscription.cancel();
    repository.dispose();
    return super.close();
  }
}
