import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import '../export_bloc.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      
      try {
        final token = await authRepository.login(event.username, event.password);
        emit(LoginSuccess(token));
      } catch (error) {
        emit(LoginFailure(error.toString()));
      }
          
    });

    on<LogoutRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await authRepository.logout();
        emit(LoginInitial());
      } catch (error) {
        emit(LoginFailure(error.toString()));
      }
    });
    on<ChangePasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await authRepository.changePassword(event.currentPassword, event.newPassword);
        emit(ChangePasswordSuccess());
      } catch (error) {
        emit(ChangePasswordFailure(error.toString()));
      }
    });
  }
}