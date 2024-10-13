

abstract class WebSocketEvent {}

class ConnectWebSocketEvent extends WebSocketEvent {}

class SendMessageEvent extends WebSocketEvent {
  final String content;
  final DateTime startDate;
  final int groupId;
  SendMessageEvent(this.content , this.startDate , this.groupId);
}

class ReceiveMessageEvent extends WebSocketEvent {
  final String message;

  ReceiveMessageEvent(this.message);
}
