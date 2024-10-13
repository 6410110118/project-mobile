import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frontend/repositories/group_repository.dart';
import '../export_bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;

  GroupBloc({required this.groupRepository}) : super(GroupStateInitial()) {
    // Handle FetchGroupEvent
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
    on<AddGroupEvent>((event, emit) async {
        emit(GroupStateLoading());
        try{
          await groupRepository.createGroup(
            name:event.name,

            startDate:event.startDate,
            endDate:event.endDate,
            
          );
          add(FetchGroupEvent());
          emit(GroupCreated('Group created successfully!'));
          
        }catch(e){
          emit(GroupError('Failed to create group. Error: $e'));
          print(e);
        }
    });
    on<AddPersonToGroupEvent>((event, emit) async {
      try {
        await groupRepository.addPersonToGroup(event.groupId, event.peopleId);
        add(FetchGroupEvent());
        emit(PersonAddedToGroupState('Person added to group successfully!'));
      } catch (e) {
        emit(GroupError('Failed to add person to group. Error: $e'));
        print(e);
      }
    });
    on<FetchGroupPeople>((event, emit) async {
      try {
        final people = await groupRepository.getPeopleInGroup(event.groupId);
        print('People fetched: $people');
        emit(GroupPeopleLoaded(people));
        
        
      } catch (e) {
        emit(GroupPeopleError('Failed to load group people. Error: $e'));
        print(e);
      }
    });
  }
}
