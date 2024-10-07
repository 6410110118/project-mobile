import 'package:bloc/bloc.dart';
import 'package:frontend/repositories/profile_repository.dart';

import 'user_event.dart';
import 'user_state.dart';


class GetMeBloc extends Bloc<GetMeEvent, GetMeState> {
  final ProfileRepository repository;

  GetMeBloc(this.repository) : super(GetMeInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(GetMeLoading());
      try {
        final user = await repository.fetchProfile();
        emit(GetMeLoaded(user));
      } catch (e) {
        emit(GetMeError(e.toString()));
      }
    });
  }
}