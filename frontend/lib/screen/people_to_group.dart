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
    // เริ่มต้นไม่ต้องตั้งค่าอะไรที่นี่
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      groupId = args as int;

      // เรียก FetchGroupPeople ที่นี่
      context.read<GroupBloc>().add(FetchGroupPeople(groupId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People in Group'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, groupId); // ส่งกลับ groupId เมื่อกดปุ่มย้อนกลับ
          },
        ),
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupPeopleLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GroupPeopleLoaded) {
            // แก้ไขการแสดงผลเพื่อหลีกเลี่ยงค่าซ้ำ
            final uniquePeople = state.people.toSet().toList(); // ลบค่าซ้ำ

            return ListView.builder(
              itemCount: uniquePeople.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(uniquePeople[index].firstname ?? 'Unnamed'),
                );
              },
            );
          } else if (state is GroupPeopleError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('No data available.'));
        },
      ),
    );
  }
}
