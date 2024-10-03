import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<StartOnboarding>((event, emit) {
      emit(OnboardingInProgress());
    });

    on<CompleteOnboarding>((event, emit) {
      emit(OnboardingCompleted());
    });
  }
}
