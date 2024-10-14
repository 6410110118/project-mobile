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
        title: const Text(
          'Group Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137), // สีหลักของแอป
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false, // ลบปุ่มย้อนกลับ
      ),
      backgroundColor: const Color(0xFFF6F7F0), // สีพื้นหลังเบจอ่อน
      body: BlocProvider(
        create: (context) => PeopleBloc(PeopleRepository())..add(FetchPeople()),
        child: BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
          if (state is PeopleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PeopleLoaded) {
            final groups = state.groups; // รายการกลุ่ม
            if (groups.isEmpty) {
              return const Center(
                child: Text(
                  'No groups available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index]; // กลุ่มแต่ละกลุ่ม
                  final imageUrl = convertGiphyUrl(group.imageUrl); // แปลง URL ของ Giphy

                  return GestureDetector( // ใช้ GestureDetector เพื่อรับการแตะ
                    onTap: () {
                      _onMessageButtonTap(group.id, widget.token); // ใช้ widget.token
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ); // จัดการข้อผิดพลาดในการโหลดภาพ
                                      },
                                    )
                                  : const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ), // แสดงไอคอนถ้า URL ไม่ถูกต้อง
                            ),
                            const SizedBox(height: 10),
                            Text(
                              group.name ?? 'Unnamed Group',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 32, 86, 137),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  'Start Date: ${group.startDate}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.event, size: 16, color: Colors.grey),
                                const SizedBox(width: 5),
                                Text(
                                  'End Date: ${group.endDate}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
