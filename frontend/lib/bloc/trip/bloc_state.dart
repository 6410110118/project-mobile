import '../../models/models.dart';

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<dynamic> trips;
  TripLoaded(this.trips);
}
class TripSubmitting extends TripState {}

class TripSubmitted extends TripState {}
class TripSearchResult extends TripState {
  final List<Trip> filteredTrips;

  TripSearchResult(this.filteredTrips);
}
class TripError extends TripState {
  final String message;
  TripError(this.message);
}