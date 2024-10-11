import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/group_repository.dart';
import '../export_bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;

  GroupBloc({required this.groupRepository}) : super(GroupStateInitial()) {
    on<FetchGroupEvent>((event, emit) async {
      emit(GroupStateLoading());

      try {
        final groupList = await groupRepository.fetchGroups();
        emit(GroupStateLoaded(groupList));
      } catch (error) {
        emit(GroupError('Failed to load data. Error: $error'));
        print(error);
      }
    });

    // Handle CreateGroupEvent
    on<CreateGroupEvent>((event, emit) async {
      emit(GroupStateLoading());

      try {
        final newGroup = await groupRepository.createGroup(
          name: event.newGroup.name,
          startDate: event.newGroup.startDate,
          endDate: event.newGroup.endDate,
        );
        emit(GroupCreated('Group created successfully: ${newGroup.name}'));

        // เพิ่ม await ตรงนี้เพื่อให้มั่นใจว่า FetchGroupEvent ทำงานหลังจากกลุ่มถูกสร้างแล้ว
        await Future.delayed(
            Duration(milliseconds: 500)); // Optional: delay เพื่อให้มั่นใจ
        add(FetchGroupEvent());
      } catch (error) {
        emit(GroupError('Failed to create group. Error: $error'));
        print(error);
      }
    });
  }
}
