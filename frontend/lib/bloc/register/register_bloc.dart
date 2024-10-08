import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/user_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;

  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {
    // Using on((event) => {...}) to handle events
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      try {
        await userRepository.register(
          email: event.email,
          username: event.username,
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          confirmPassword: event.confirmPassword,
          role: event.role,
        );
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(error: e.toString()));
      }
    });
  }
}