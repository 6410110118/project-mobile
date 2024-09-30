import 'package:bloc/bloc.dart';
import '../export_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState()) {
    on<FirstNameChanged>((event, emit) {
      emit(state.copyWith(firstName: event.firstName));
    });

    on<LastNameChanged>((event, emit) {
      emit(state.copyWith(lastName: event.lastName));
    });

    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<ConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });

    on<ToggleConfirmPasswordVisibility>((event, emit) {
      emit(state.copyWith(
          obscureConfirmPassword: !state.obscureConfirmPassword));
    });

    on<RoleChanged>((event, emit) {
      emit(state.copyWith(role: event.role));
    });

    on<FormSubmitted>((event, emit) {
      // ตรวจสอบว่าช่องข้อมูลทั้งหมดถูกกรอกครบถ้วนหรือไม่
      if (state.firstName.isEmpty ||
          state.lastName.isEmpty ||
          state.email.isEmpty ||
          state.password.isEmpty ||
          state.confirmPassword.isEmpty ||
          state.role == null) {
        emit(RegisterFailure(error: 'กรุณากรอกข้อมูลให้ครบถ้วน'));
        return;
      }

      // ตรวจสอบว่ารหัสผ่านมีอย่างน้อย 8 ตัวหรือไม่
      if (state.password.length < 8) {
        emit(RegisterFailure(error: 'รหัสผ่านต้องมีอย่างน้อย 8 ตัว'));
        return;
      }

      // ตรวจสอบว่ารหัสผ่านและยืนยันรหัสผ่านตรงกันหรือไม่
      if (state.password != state.confirmPassword) {
        emit(RegisterFailure(error: 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน'));
        return;
      }

      // ถ้าข้อมูลถูกต้องทั้งหมด, ส่ง event success
      emit(RegisterSuccess(role: state.role ?? 'User'));
    });
  }
}
