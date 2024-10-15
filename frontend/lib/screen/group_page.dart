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
  String token = '';

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
        title: const Text(
          'Group',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137), // สีหลักของแอป
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF6F7F0), // สีพื้นหลังเบจอ่อน
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
                  context.read<GroupBloc>().add(FetchGroupEvent());
                }
              },
              child: GroupListView(
                searchQuery: searchQuery,
                token: token,
              ), // ส่ง searchQuery ไปกรองข้อมูล
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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF707070), width: 1.5),
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFF6F7F0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          style: const TextStyle(fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'Search',
            prefixIcon:
                Icon(Icons.search, color: Color.fromARGB(255, 32, 86, 137)),
            border: InputBorder.none,
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
              context.read<GroupBloc>().add(FetchGroupEvent());
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 32, 86, 137),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Add New Group',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
