import 'package:equatable/equatable.dart';

abstract class JoinRequestEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchJoinRequests extends JoinRequestEvent {}

class ApproveJoinRequest extends JoinRequestEvent {
  final int itemId;
  final int joinRequestId;

  ApproveJoinRequest(this.itemId, this.joinRequestId);
}

class RejectJoinRequest extends JoinRequestEvent {
  final int itemId;
  final int joinRequestId;

  RejectJoinRequest(this.itemId, this.joinRequestId);
}

