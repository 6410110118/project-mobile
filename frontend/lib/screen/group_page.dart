import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/group_repository.dart';
import 'package:frontend/screen/add_group_page.dart';
import 'package:frontend/widgets/group_list_view.dart';

class GroupScreen extends StatefulWidget {
  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch user data when the page is initialized
    context.read<GroupBloc>().add(FetchGroupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Group',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: BlocListener<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Group added successfully!')),
                  );
                  // โหลดข้อมูลกลุ่มใหม่หลังจากสร้างสำเร็จ
                  context.read<GroupBloc>().add(FetchGroupEvent());
                }
              },
              child: GroupListView(
                  searchQuery: searchQuery), // ส่ง searchQuery ไปกรองข้อมูล
            ),
          ),
          _buildAddGroupButton(context),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
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
    );
  }

  Widget _buildAddGroupButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGroupPage()),
          ).then((isGroupAdded) {
            if (isGroupAdded == true) {
              // ถ้ามีกลุ่มที่ถูกเพิ่มใหม่ให้ทำการดึงข้อมูลใหม่
              context.read<GroupBloc>().add(FetchGroupEvent());
            }
          });
        },
        child: Text('Add New Group'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
