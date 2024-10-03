
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/group_repository.dart';

import '../export_bloc.dart';

class GroupBloc extends Bloc<FetchGroupEvent, GroupState> {
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
  }
}
