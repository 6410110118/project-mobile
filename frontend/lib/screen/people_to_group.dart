import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';

class GroupPeoplePage extends StatefulWidget {
  @override
  State<GroupPeoplePage> createState() => _GroupPeoplePageState();
}

class _GroupPeoplePageState extends State<GroupPeoplePage> {
  late int groupId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      groupId = args as int;
      context.read<GroupBloc>().add(FetchGroupPeople(groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'People in Group',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 32, 86, 137),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF6F7F0),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupPeopleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GroupPeopleLoaded) {
            final uniquePeople = state.people.toSet().toList();

            if (uniquePeople.isEmpty) {
              return const Center(
                child: Text(
                  'No people available in this group.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: uniquePeople.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color.fromARGB(255, 32, 86, 137),
                      child: Text(
                        '${index + 1}', // แสดงลำดับสมาชิก
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      uniquePeople[index].firstname ?? 'Unnamed',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 32, 86, 137),
                      ),
                    ),
                    subtitle: const Text(
                      'Member',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          } else if (state is GroupPeopleError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              'No data available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
