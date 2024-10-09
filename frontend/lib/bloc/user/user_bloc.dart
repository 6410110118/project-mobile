import 'package:bloc/bloc.dart';
import 'package:frontend/repositories/profile_repository.dart';

import 'user_event.dart';
import 'user_state.dart';


class GetMeBloc extends Bloc<GetMeEvent, GetMeState> {
  final ProfileRepository repository;

  GetMeBloc(this.repository) : super(GetMeInitial()) {
    on<FetchUserData>((event, emit) async {
      emit(GetMeLoading());
      try {
        final user = await repository.fetchProfile();
        emit(GetMeLoaded(user));
      } catch (e) {
        emit(GetMeError(e.toString()));
      }
    });
    on<EditProfile>((event, emit) async {
      emit(GetMeLoading());
      try {
        // เรียกใช้งาน editProfile จาก repository โดยส่งข้อมูลที่ต้องการแก้ไข
        await repository.updateUser(
          email: event.email,
          
          firstName: event.firstName,
          lastName: event.lastName,
          role: event.role,
        );

        emit(ProfileEdited()); // อัปเดตสถานะเมื่อแก้ไขสำเร็จ
      } catch (e) {
        emit(GetMeError(e.toString())); // แสดงข้อผิดพลาดหากเกิดข้อผิดพลาด
      }
    });
    on<ChangePasswordEvent>((event, emit) async {
      emit(ChangePasswordLoading());
      try {
        await repository.changePassword(event.currentPassword, event.newPassword);
        emit(ChangePasswordSuccess());
      } catch (error) {
        emit(ChangePasswordFailure(error.toString()));
      }
    });
    on<UploadImageEvent>((event , emit) async {
      emit(ImageUploadLoading());
      try {
        
        await repository.uploadImage( event.imageData);
        

        emit(ImageUploaded()); 
        add(FetchUserData());
      } catch (e) {
        emit(ImageUploadFailure(e.toString())); 
      }
    });
    
    
  }
}