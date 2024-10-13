import 'package:frontend/models/person.dart';

abstract class GroupState {}

class GroupStateInitial extends GroupState {}

class GroupStateLoading extends GroupState {}


class GroupStateLoaded extends GroupState {
  final List<dynamic> groups;
  GroupStateLoaded(this.groups);
}

class GroupCreated extends GroupState {
  final String message;

  GroupCreated(this.message);
}

class GroupError extends GroupState {
  final String message;
  GroupError(this.message);
}

// State ที่จะถูกส่งเมื่อเพิ่มคนสำเร็จ
class PersonAddedToGroupState extends GroupState {
  final String message;

  PersonAddedToGroupState(this.message);
}


class GroupPeopleInitial extends GroupState {}

class GroupPeopleLoading extends GroupState {}

class GroupPeopleLoaded extends GroupState {
  final List<Person> people;

  GroupPeopleLoaded(this.people);
}

class GroupPeopleError extends GroupState {
  final String message;

  GroupPeopleError(this.message);
}