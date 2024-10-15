import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/message/message_bloc.dart';
import '../bloc/message/message_event.dart';
import '../bloc/message/message_state.dart';
import '../repositories/websocket_repository.dart';

class MessagePage extends StatefulWidget {
  final int groupId;
  final String token;

  const MessagePage({required this.groupId, required this.token, Key? key})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late WebSocketBloc _webSocketBloc;
  late TextEditingController _messageController;
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();

    WebSocketRepository repository =
        WebSocketRepository(widget.groupId, widget.token);
    _webSocketBloc = WebSocketBloc(repository);
    _messageController = TextEditingController();

    _webSocketBloc.add(ConnectWebSocketEvent());

    _webSocketBloc.stream.listen((state) {
      if (state is WebSocketMessageReceived) {
        setState(() {
          _messages.add(state.message);
        });
      }
    });
  }

  @override
  void dispose() {
    _webSocketBloc.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Messages in Group ${widget.groupId}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFF6F7F0),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Align(
                    alignment: index % 2 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? const Color.fromARGB(255, 32, 86, 137)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        _messages[index],
                        style: TextStyle(
                          color: index % 2 == 0 ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color(0xFF707070), width: 1.5),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: Color.fromARGB(255, 32, 86, 137)),
                  onPressed: () async {
                    final message = _messageController.text;
                    if (message.isNotEmpty) {
                      try {
                        await _webSocketBloc.repository.sendMessageToApi(
                            message, DateTime.now(), widget.groupId);
                        _messageController.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error sending message: $e")),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
