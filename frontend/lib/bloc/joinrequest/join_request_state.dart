import 'package:equatable/equatable.dart';
import 'package:frontend/models/joinrequest.dart';

abstract class JoinRequestState extends Equatable {
  @override
  List<Object> get props => [];
}

class JoinRequestInitial extends JoinRequestState {}

class JoinRequestLoading extends JoinRequestState {}

class JoinRequestLoaded extends JoinRequestState {
  final List<JoinRequest> joinRequests;

  JoinRequestLoaded(this.joinRequests);

  @override
  List<Object> get props => [joinRequests];
}

class JoinRequestError extends JoinRequestState {
  final String error;

  JoinRequestError(this.error);

  @override
  List<Object> get props => [error];
}
