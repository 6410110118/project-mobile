import 'package:flutter_bloc/flutter_bloc.dart';
import '../export_bloc.dart';


class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(PageLoaded(0)) {
    on<PageSelected>((event, emit) {
      emit(PageLoaded(event.index));
    });
  }
}