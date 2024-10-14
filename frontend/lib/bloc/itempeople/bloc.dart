import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/itempeople/event.dart';
import 'package:frontend/bloc/itempeople/state.dart';
import 'package:frontend/repositories/itempeople_repository.dart';

class ItemPeopleBloc extends Bloc<ItemPeopleEvent, ItemPeopleState> {
  final ItemPeopleRepository itemPeopleRepository;

  ItemPeopleBloc(this.itemPeopleRepository) : super(ItemPeopleInitial()) {
    on<FetchItemPeople>((event, emit) async {
      emit(ItemPeopleLoading());
      try {
        final itemPeopleList = await itemPeopleRepository.fetchItemPeople();
        emit(ItemPeopleLoaded(itemPeopleList));
      } catch (e) {
        emit(ItemPeopleError('Failed to fetch item people: $e'));
      }
    });
  }
}
