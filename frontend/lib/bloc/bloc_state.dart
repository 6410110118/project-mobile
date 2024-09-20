import 'package:equatable/equatable.dart';

import '../models/home.dart';


abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<Trip> trips;

  const TripLoaded(this.trips);

  @override
  List<Object?> get props => [trips];
}
class TripLateStatus extends TripState {
  final bool isLate;

  const TripLateStatus(this.isLate);

  @override
  List<Object?> get props => [isLate];
}

class TripRoleStatus extends TripState {
  final bool isLeader;

  const TripRoleStatus(this.isLeader);

  @override
  List<Object?> get props => [isLeader];
}

class TripError extends TripState {
  final String message;

  const TripError(this.message);

  @override
  List<Object?> get props => [message];
}
