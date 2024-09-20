import 'package:bloc/bloc.dart';

import '../models/home.dart';

import 'export_bloc.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  TripBloc() : super(TripInitial()) {
    on<LoadTrips>(_onLoadTrips);
    on<AddTrip>(_onAddTrip);
    on<UpdateTrip>(_onUpdateTrip);
    on<DeleteTrip>(_onDeleteTrip);
    on<CheckTripStatus>(_onCheckTripStatus);
    on<CheckTripRole>(_onCheckTripRole);
  }

  void _onLoadTrips(LoadTrips event, Emitter<TripState> emit) {
    emit(TripLoading());
    try {
      // Sample trip data
      final trips = [
        Trip(id: 1, imageUrl: 'url1', tripName: 'Trip 1', description: 'dassda', endtime: DateTime.now().add(Duration(days: 1)), role: false),
        Trip(id: 2, imageUrl: 'url2', tripName: 'Trip 2', description: "asdda", endtime: DateTime.now().add(Duration(days: 2))  , role: true),
      ];
      emit(TripLoaded(trips));
    } catch (e) {
      emit(const TripError('Failed to load trips'));
    }
  }

  void _onAddTrip(AddTrip event, Emitter<TripState> emit) {
    if (state is TripLoaded) {
      final updatedTrips = List<Trip>.from((state as TripLoaded).trips)..add(event.trip);
      emit(TripLoaded(updatedTrips));
    }
  }

  void _onUpdateTrip(UpdateTrip event, Emitter<TripState> emit) {
    if (state is TripLoaded) {
      final updatedTrips = (state as TripLoaded).trips.map((trip) {
        return trip.id == event.trip.id ? event.trip : trip;
      }).toList();
      emit(TripLoaded(updatedTrips));
    }
  }

  void _onDeleteTrip(DeleteTrip event, Emitter<TripState> emit) {
    if (state is TripLoaded) {
      final updatedTrips = (state as TripLoaded).trips.where((trip) => trip.id != event.tripId).toList();
      emit(TripLoaded(updatedTrips));
    }
  }

  void _onCheckTripStatus(CheckTripStatus event, Emitter<TripState> emit) {
    if (state is TripLoaded) {
      final trip = (state as TripLoaded).trips.firstWhere((trip) => trip.id == event.tripId);
      emit(TripLateStatus(trip.islate));
    }
  }

  void _onCheckTripRole(CheckTripRole event, Emitter<TripState> emit) {
    if (state is TripLoaded) {
      final trip = (state as TripLoaded).trips.firstWhere((trip) => trip.id == event.tripId);
      emit(TripRoleStatus(trip.role));
    }
  }
}