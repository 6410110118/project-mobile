import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';
import '../models/groups.dart'; // Ensure you import your Group model

class AddGroupDialog extends StatefulWidget {
  @override
  _AddGroupDialogState createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  String groupName = '';
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupCreated) {
          // Show success dialog when group is created
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Create group success'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the success popup
                      Navigator.of(context).pop(); // Close the AddGroupDialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (state is GroupError) {
          // Handle error case if group creation fails
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the error popup
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: AlertDialog(
        title: Text('Create New Group'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Group Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
                onSaved: (value) {
                  groupName = value!;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await _selectDate(context);
                  if (pickedDate != null) {
                    setState(() {
                      startDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  startDate != null
                      ? 'Start Date: ${startDate!.toLocal()}'.split(' ')[0]
                      : 'Select Start Date',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await _selectDate(context);
                  if (pickedDate != null) {
                    setState(() {
                      endDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  endDate != null
                      ? 'End Date: ${endDate!.toLocal()}'.split(' ')[0]
                      : 'Select End Date',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
          ),
          ElevatedButton(
            child: Text('Create'),
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  startDate != null &&
                  endDate != null) {
                _formKey.currentState!.save();

                // Create a new Group instance and trigger the Bloc event
                Group newGroup = Group(
                  name: groupName,
                  startDate: startDate!,
                  endDate: endDate!,
                );

                BlocProvider.of<GroupBloc>(context)
                    .add(CreateGroupEvent(newGroup: newGroup));
              }
            },
          ),
        ],
      ),
    );
  }

  // Function to select date
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked;
  }
}
