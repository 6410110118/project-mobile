abstract class WebSocketState {}

class WebSocketInitial extends WebSocketState {}

class WebSocketMessageReceived extends WebSocketState {
  final String message;
  

  WebSocketMessageReceived(this.message );
}

class WebSocketError extends WebSocketState {
  final String message;

  WebSocketError(this.message);
}
