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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Add People to Group',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Username',
          labelStyle: const TextStyle(color: Colors.blueGrey),
          hintText: 'Enter Username',
          hintStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueGrey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 32, 86, 137), width: 2),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 86, 137),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            final username = _controller.text.trim();
            if (username.isNotEmpty) {
              final personId =
                  await peopleRepository.getPeopleIdByUsername(username);
              if (personId != null) {
                context.read<GroupBloc>().add(AddPersonToGroupEvent(
                    groupId: groupId, peopleId: personId));
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('No user found with that username')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a valid username')),
              );
            }
          },
        ),
      ],
    );
  }
}
