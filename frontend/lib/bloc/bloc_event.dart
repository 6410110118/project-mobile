import 'package:equatable/equatable.dart';

import '../models/home.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrips extends TripEvent {}

class AddTrip extends TripEvent {
  final Trip trip;

  const AddTrip(this.trip);

  @override
  List<Object?> get props => [trip];
}

class UpdateTrip extends TripEvent {
  final Trip trip;

  const UpdateTrip(this.trip);

  @override
  List<Object?> get props => [trip];
}
class CheckTripStatus extends TripEvent {
  final int tripId;

  const CheckTripStatus(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class CheckTripRole extends TripEvent {
  final int tripId;

  const CheckTripRole(this.tripId);

  @override
  List<Object?> get props => [tripId];
}



class DeleteTrip extends TripEvent {
  final int tripId;

  const DeleteTrip(this.tripId);

  @override
  List<Object?> get props => [tripId];
}
