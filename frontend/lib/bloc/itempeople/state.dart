import 'package:frontend/models/itempeople.dart';

abstract class ItemPeopleState {}

class ItemPeopleInitial extends ItemPeopleState {}

class ItemPeopleLoading extends ItemPeopleState {}

class ItemPeopleLoaded extends ItemPeopleState {
  final List<ItemPeople> itemPeopleList;
  ItemPeopleLoaded(this.itemPeopleList);
}

class ItemPeopleError extends ItemPeopleState {
  final String message;
  ItemPeopleError(this.message);
}