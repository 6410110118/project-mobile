import 'package:bloc/bloc.dart';
import '../export_bloc.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordState()) {
    on<OldPasswordChanged>((event, emit) {
      emit(state.copyWith(oldPassword: event.oldPassword));
    });

    on<NewPasswordChanged>((event, emit) {
      emit(state.copyWith(newPassword: event.newPassword));
    });

    on<ConfirmPasswordChange>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<ToggleOldPasswordVisibility>((event, emit) {
      emit(state.copyWith(obscureOldPassword: !state.obscureOldPassword));
    });

    on<ToggleNewPasswordVisibility>((event, emit) {
      emit(state.copyWith(obscureNewPassword: !state.obscureNewPassword));
    });

    on<ToggleConfirmPasswordChangeVisibility>((event, emit) {
      emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
    });

    on<ChangePasswordSubmitted>((event, emit) {
      if (state.newPassword == state.confirmPassword) {
        emit(ChangePasswordSuccess());
      }
    });
  }
}

class ChangePasswordSuccess extends ChangePasswordState {}