import 'package:bloc/bloc.dart';
import 'package:frontend/bloc/welcome/welcome_event.dart';
import '../export_bloc.dart';

class TravelBloc extends Bloc<TravelEvent, TravelState> {
  TravelBloc() : super(TravelInitial()) {
    on<LoadTravelPage>((event, emit) async {
      // Simulate loading with a delay (5 seconds here)
      await Future.delayed(const Duration(
          seconds: 5)); // Keep this 5 seconds to display the first page longer
      emit(TravelLoaded());
    });
  }
}
