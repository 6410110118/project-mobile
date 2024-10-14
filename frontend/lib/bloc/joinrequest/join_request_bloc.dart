import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/join_request_repository.dart';
import 'join_request_event.dart';
import 'join_request_state.dart';

class JoinRequestBloc extends Bloc<JoinRequestEvent, JoinRequestState> {
  final JoinRequestRepository joinRequestRepository;

  JoinRequestBloc(this.joinRequestRepository) : super(JoinRequestInitial()) {
    on<FetchJoinRequests>(_onFetchJoinRequests);
    on<ApproveJoinRequest>(_onApproveJoinRequest);
    on<RejectJoinRequest>(_onRejectJoinRequest);
  }

  void _onFetchJoinRequests(
      FetchJoinRequests event, Emitter<JoinRequestState> emit) async {
    emit(JoinRequestLoading());
    try {
      final joinRequests = await joinRequestRepository.fetchJoinRequests();
      emit(JoinRequestLoaded(joinRequests));
    } catch (e) {
      emit(JoinRequestError('Failed to fetch join requests'));
    }
  }

  void _onApproveJoinRequest(
      ApproveJoinRequest event, Emitter<JoinRequestState> emit) async {
    emit(JoinRequestLoading());
    try {
      await joinRequestRepository.respondToJoinRequest(event.itemId, event.joinRequestId, true);
      add(FetchJoinRequests());  // Re-fetch join requests to update the list
    } catch (e) {
      emit(JoinRequestError('Failed to approve join request'));
    }
  }

  void _onRejectJoinRequest(
      RejectJoinRequest event, Emitter<JoinRequestState> emit) async {
    emit(JoinRequestLoading());
    try {
      await joinRequestRepository.respondToJoinRequest(event.itemId, event.joinRequestId, false);
      add(FetchJoinRequests());  // Re-fetch join requests to update the list
    } catch (e) {
      emit(JoinRequestError('Failed to reject join request'));
    }
  }
}
