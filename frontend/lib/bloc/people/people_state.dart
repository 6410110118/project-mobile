import 'package:frontend/models/groups.dart';

abstract class PeopleState {}

class PeopleInitial extends PeopleState {}

class PeopleLoading extends PeopleState {}

class PeopleLoaded extends PeopleState {
  final List<Group> groups; 

  PeopleLoaded(this.groups);
}

class PeopleError extends PeopleState {
  final String message;

  PeopleError(this.message);
}
