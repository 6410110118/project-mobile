abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<dynamic> trips;
  TripLoaded(this.trips);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}