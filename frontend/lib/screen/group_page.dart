import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/group_repository.dart';

import '../models/groups.dart';

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: BlocProvider(
        create: (context) => GroupBloc(groupRepository: GroupRepository())
          ..add(FetchGroupEvent()),
        child: GroupListView(),
      ),
    );
  }
}

class GroupListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupStateLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is GroupStateLoaded) {
          return ListView.builder(
            itemCount: state.groups.length,
            itemBuilder: (context, index) {
              // ใช้ Group model ที่แก้ไขแล้ว
              final Group group = state.groups[index];
              return ListTile(
                title: Text(group.name),
              );
            },
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
