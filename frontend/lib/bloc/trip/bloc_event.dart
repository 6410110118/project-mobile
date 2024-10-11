import '../../models/models.dart';

abstract class TripEvent {}

class FetchTripEvent extends TripEvent {
  
  FetchTripEvent();
}

class SubmitTrip extends TripEvent {
  final Trip trips;

  SubmitTrip(this.trips);
}
class SearchTripEvent extends TripEvent {
  final String query;

  SearchTripEvent({required this.query});
}

class JoinTripEvent extends TripEvent {
  final Trip trip;

  JoinTripEvent({required this.trip});
}