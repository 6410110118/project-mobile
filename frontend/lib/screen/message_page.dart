import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/message/message_bloc.dart';
import '../bloc/message/message_event.dart';
import '../bloc/message/message_state.dart';
import '../repositories/websocket_repository.dart';

class MessagePage extends StatefulWidget {
  final int groupId; // ประกาศ groupId
  final String token;

  const MessagePage({required this.groupId, required this.token, Key? key})
      : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late WebSocketBloc _webSocketBloc;
  late TextEditingController _messageController;
  final List<String> _messages = []; // สร้าง List เพื่อเก็บข้อความ

  @override
  void initState() {
    super.initState();
    // สร้าง WebSocketRepository และ WebSocketBloc สำหรับการเชื่อมต่อ WebSocket
    WebSocketRepository repository =
        WebSocketRepository(widget.groupId, widget.token);
    _webSocketBloc = WebSocketBloc(repository);
    _messageController = TextEditingController();

    // เริ่มเชื่อมต่อ WebSocket
    _webSocketBloc.add(ConnectWebSocketEvent());

    // ฟังข้อความที่ได้รับ
    _webSocketBloc.stream.listen((state) {
      if (state is WebSocketMessageReceived) {
        setState(() {
          _messages.add(state.message); // เพิ่มข้อความที่ได้รับไปยัง List
        });
      }
    });
  }

  @override
  void dispose() {
    _webSocketBloc.close(); // ปิด Bloc
    _messageController.dispose(); // ปิด TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Messages in Group ${widget.groupId}', // ใช้ groupId
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137), // สีหลักของแอป
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // เปลี่ยนสีของไอคอนลูกศรเป็นสีขาว
        ),
      ),

      backgroundColor: const Color(0xFFF6F7F0), // สีพื้นหลังเบจอ่อน
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length, // ใช้จำนวนข้อความใน List
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
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        contentPadding: const EdgeInsets.symmetric(
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
                        // ส่งข้อความไปยัง API พร้อม groupId และวันที่
                        await _webSocketBloc.repository.sendMessageToApi(
                            message, DateTime.now(), widget.groupId);
                        _messageController.clear(); // ล้างข้อความใน TextField
                      } catch (e) {
                        // จัดการข้อผิดพลาดที่เกิดขึ้น
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
