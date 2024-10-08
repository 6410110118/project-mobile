import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/group_repository.dart';
import '../models/groups.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // ปิดการแสดงผลปุ่ม Back
        title: Text('Group',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => GroupBloc(groupRepository: GroupRepository())
                ..add(FetchGroupEvent()),
              child: GroupListView(searchQuery: searchQuery),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // การทำงานเมื่อกดปุ่ม Add New Group
              },
              child: Text('Add New Group'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupListView extends StatelessWidget {
  final String searchQuery;

  GroupListView({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupStateLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GroupStateLoaded) {
          // กรองข้อมูลตามการค้นหา
          final List filteredGroups = state.groups.where((group) {
            return group.name.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment:
                      Alignment.centerLeft, // จัดตำแหน่งข้อความให้ชิดซ้าย
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

                    // แปลง URL ของ Giphy ให้เป็น URL ที่สามารถโหลดรูปภาพได้
                    final String imageUrl = convertGiphyUrl(group.imageUrl);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
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
                          title: Text(group.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text('Start date: ${group.startDate}'),
                              Text('End date: ${group.endDate}'),
                            ],
                          ),
                          onTap: () {
                            // ทำงานเมื่อกดเลือกกรุ๊ป
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
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('No groups available'));
        }
      },
    );
  }
}

String convertGiphyUrl(String? url) {
  if (url == null ||
      !(url.contains('giphy.com/stickers/') ||
          url.contains('giphy.com/media/'))) {
    return ''; // คืนค่าว่างถ้า URL ไม่ถูกต้อง
  }

  final uri = Uri.parse(url);
  final segments = uri.pathSegments;

  if (segments.length < 2) {
    return ''; // คืนค่าว่างถ้า segments ไม่เพียงพอ
  }

  final gifId =
      segments.last.split('-').last; // ดึง ID ออกมาหลังเครื่องหมาย '-'
  return 'https://media.giphy.com/media/$gifId/giphy.gif'; // ใช้ URL ของ Giphy media เพื่อดึงรูปภาพ GIF
}
