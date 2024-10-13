import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/message_page.dart';
import '../bloc/export_bloc.dart';
import '../models/groups.dart';

class GroupListView extends StatelessWidget {
  final String searchQuery;
  final String token; // เพิ่มตัวแปร token

  GroupListView({required this.searchQuery, required this.token}); // เพิ่ม token ในคอนสตรัคเตอร์

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        print("Current State: $state");
        if (state is GroupStateLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GroupStateLoaded) {
          
          // กรองกลุ่มตาม searchQuery
          final List<Group> filteredGroups = state.groups
              .cast<Group>() // ทำการแปลงเป็น List<Group>
              .where((group) {
            return group.name != null &&
                group.name!.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          // ตรวจสอบว่ามีกลุ่มที่ตรงกับการค้นหาหรือไม่
          if (filteredGroups.isEmpty) {
            return Center(child: Text('No results found for your search'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredGroups.length} Results matched your search',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {
                    final Group group = filteredGroups[index];
                    final String imageUrl = convertGiphyUrl(group.imageUrl);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 50,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.broken_image, size: 60);
                                    },
                                  )
                                : Icon(Icons.broken_image, size: 60),
                          ),
                          title: Text(group.name ?? 'Unnamed Group'), // แสดงชื่อกลุ่มหรือ 'Unnamed Group'
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Start date: ${group.startDate ?? 'N/A'}'), // ปรับให้แสดง 'N/A' หากไม่มีวันที่
                              Text('End date: ${group.endDate ?? 'N/A'}'), // ปรับให้แสดง 'N/A' หากไม่มีวันที่
                            ],
                          ),
                           onTap: () {
                            final int groupId = group.id; // ใช้ค่า id ของกลุ่ม
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagePage(groupId: groupId, token: token), // ส่ง token ไปด้วย
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is GroupError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('No groups available'));
        }
      },
    );
  }
}

String convertGiphyUrl(String? url) {
  if (url == null || !(url.contains('giphy.com/stickers/') || url.contains('giphy.com/media/'))) {
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
