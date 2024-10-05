import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/trip.dart';
import '../../repositories/trip_repository.dart'; // นำเข้า TripRepository
import '../export_bloc.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final TripRepository tripRepository; // เปลี่ยนเป็น TripRepository

  TripBloc({required this.tripRepository}) : super(TripInitial()) {
    on<FetchTripEvent>((event, emit) async {
      emit(TripLoading());

      try {
        // เรียกข้อมูลจาก TripRepository
        final List<Trip> tripList = await tripRepository.fetchTrips(); // ดึงข้อมูล trips
        emit(TripLoaded(tripList));
      } catch (error) {
        // ถ้ามีข้อผิดพลาดขณะดึงข้อมูล
        emit(TripError('Failed to load data. Error: $error'));
        print(error);
      }
    });

    on<SubmitTrip>((event, emit) async {
      emit(TripSubmitting());

      try {
        await tripRepository.postTrip(event.trips); // เปลี่ยน event.trips เป็น event.trip
        emit(TripSubmitted());

        // หลังจากส่งทริปสำเร็จ ให้ดึงข้อมูลใหม่
        emit(TripLoading()); // Optional: Emit loading state while fetching
        final List<Trip> tripList = await tripRepository.fetchTrips(); // ดึงข้อมูล trips ใหม่
        emit(TripLoaded(tripList)); // ส่ง trips ที่ถูกโหลด
      } catch (e) {
        emit(TripError('Failed to submit data. Error: $e'));
        print(e);
      }
    });

    on<SearchTripEvent>((event, emit) {
      final currentState = state;

      if (currentState is TripLoaded) {
        // กรองทริปตามคำค้นหา
        final filteredTrips = currentState.trips.where((trip) {
          return trip.tripName?.toLowerCase().contains(event.query.toLowerCase()) ?? false;
        }).cast<Trip>().toList();

        // ส่งผลลัพธ์การค้นหาหากมีทริป
        emit(TripSearchResult(filteredTrips)); // ไม่ต้องแปลง List
      } else {
        // หาก currentState ไม่เป็น TripLoaded
        emit(TripSearchResult([])); // ส่งรายการว่าง
      }
    });
  }
}
