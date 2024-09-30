import 'package:bloc/bloc.dart';
import '/bloc/export_bloc.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(const BottomNavigationState(selectedIndex: 0));

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is ChangeBottomNavigation) {
      yield BottomNavigationState(selectedIndex: event.selectedIndex);
    }
  }
}
