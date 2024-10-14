import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/people/people_bloc.dart';
import 'package:frontend/bloc/people/people_event.dart';
import 'package:frontend/bloc/people/people_state.dart';
import 'package:frontend/repositories/people_repository.dart';
import 'package:frontend/screen/message_page.dart'; // import MessagePage

class GroupPage extends StatefulWidget {
  final String token; // เพิ่มตัวแปร token

  GroupPage({required this.token}); // รับ token ผ่าน constructor

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Details'),
        automaticallyImplyLeading: false, // ลบปุ่มย้อนกลับ
      ),
      body: BlocProvider(
        create: (context) => PeopleBloc(PeopleRepository())..add(FetchPeople()),
        child: BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
          if (state is PeopleLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PeopleLoaded) {
            final groups = state.groups; // รายการกลุ่ม
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index]; // กลุ่มแต่ละกลุ่ม
                final imageUrl = convertGiphyUrl(group.imageUrl); // แปลง URL ของ Giphy

                return GestureDetector( // ใช้ GestureDetector เพื่อรับการแตะ
                  onTap: () {
                    _onMessageButtonTap(group.id, widget.token); // ใช้ widget.token
                  },
                  child: Card(
                    child: Column(
                      children: [
                        imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text('Failed to load image'); // จัดการข้อผิดพลาดในการโหลดภาพ
                                },
                              )
                            : Text('Image URL is invalid'), // แสดงข้อความถ้า URL ไม่ถูกต้อง
                        Text(group.name!),
                        Text('Start Date: ${group.startDate}'),
                        Text('End Date: ${group.endDate}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is PeopleError) {
            return Center(child: Text(state.message));
          }
          return Container();
        }),
      ),
    );
  }

  // ฟังก์ชันในการจัดการการนำทางไปยัง MessagePage
  void _onMessageButtonTap(int groupId, String token) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagePage(groupId: groupId, token: token), // ส่ง groupId และ token ไปยัง MessagePage
      ),
    );
  }

  String convertGiphyUrl(String? url) {
    if (url == null ||
        !(url.contains('giphy.com/stickers/') ||
            url.contains('giphy.com/media/'))) {
      return '';
    }

    final uri = Uri.parse(url);
    final segments = uri.pathSegments;

    if (segments.length < 2) {
      return '';
    }

    final gifId = segments.last.split('-').last;
    return 'https://media.giphy.com/media/$gifId/giphy.gif';
  }
}
