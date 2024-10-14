import 'package:bloc/bloc.dart';

import 'package:frontend/repositories/people_repository.dart';

import 'people_event.dart';
import 'people_state.dart';


class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  final PeopleRepository peopleRepository;

  PeopleBloc(this.peopleRepository) : super(PeopleInitial()) {
    on<FetchPeople>((event, emit) async {
      emit(PeopleLoading());
      try {
        final people = await peopleRepository.fetchGroup();
        emit(PeopleLoaded(people));
      } catch (e) {
        emit(PeopleError('Failed to fetch data'));
      }
    });
  }
}
