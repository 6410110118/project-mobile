import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/group_repository.dart';


class GroupBloc extends Bloc<FetchGroupEvent, GroupState> {
  final GroupRepository tripRepository; // เปลี่ยนเป็น TripRepository

  GroupBloc( {required  this.tripRepository}) : super(GroupStateInitial()) {
    on<FetchGroupEvent>((event, emit) async {
      emit(GroupStateLoading());

      try {
        // เรียกข้อมูลจาก TripRepository
        final tripList = await tripRepository.fetchGroups(); // ดึงข้อมูล trips

        emit(GroupStateLoaded(tripList));
      } catch (error) {
        // ถ้ามีข้อผิดพลาดขณะดึงข้อมูล
        emit(GroupError('Failed to load data. Error: $error'));
        print(error);
      }
    });
  }
}