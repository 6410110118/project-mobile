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
