
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/trip_repository.dart';
// นำเข้า TripRepository

import '../export_bloc.dart';

class TripBloc extends Bloc<FetchTripEvent, TripState> {
  final TripRepository tripRepository; // เปลี่ยนเป็น TripRepository

  TripBloc( {required  this.tripRepository}) : super(TripInitial()) {
    on<FetchTripEvent>((event, emit) async {
      emit(TripLoading());

      try {
        // เรียกข้อมูลจาก TripRepository
        final tripList = await tripRepository.fetchTrips(); // ดึงข้อมูล trips

        emit(TripLoaded(tripList));
      } catch (error) {
        // ถ้ามีข้อผิดพลาดขณะดึงข้อมูล
        emit(TripError('Failed to load data. Error: $error'));
        print(error);
      }
    });
  }
}
