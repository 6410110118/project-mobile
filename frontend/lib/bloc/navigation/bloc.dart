import 'package:flutter_bloc/flutter_bloc.dart';
import '../export_bloc.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc()
      : super(const BottomNavigationState(selectedIndex: 0)) {
    // การจัดการ event ใน constructor โดยใช้ on
    on<ChangeBottomNavigation>((event, emit) {
      emit(BottomNavigationState(selectedIndex: event.selectedIndex));
    });
  }
}
