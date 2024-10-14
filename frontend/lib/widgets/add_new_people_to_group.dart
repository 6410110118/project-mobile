import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';
import '../repositories/people_repository.dart';

class AddPeopleDialog extends StatelessWidget {
  final int groupId;
  final PeopleRepository peopleRepository;

  AddPeopleDialog({required this.groupId, required this.peopleRepository});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return AlertDialog(
      title: Text('Add People to Group'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter Username'), // เปลี่ยนเป็น Username
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () async {
            final username = _controller.text.trim(); // เปลี่ยนชื่อ variable
            if (username.isNotEmpty) {
              final personId = await peopleRepository.getPeopleIdByUsername(username); // เรียกใช้ฟังก์ชันที่ถูกต้อง
              
              if (personId != null) {
                // เรียกใช้ event เพื่อเพิ่มคน
                context.read<GroupBloc>().add(AddPersonToGroupEvent(groupId: groupId, peopleId: personId));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found with that username'))); // เปลี่ยนข้อความ
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a valid username'))); // เปลี่ยนข้อความ
            }
          },
        ),
      ],
    );
  }
}
