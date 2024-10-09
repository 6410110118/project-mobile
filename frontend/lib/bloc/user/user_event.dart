




import 'dart:typed_data';

import 'package:frontend/models/user.dart';

abstract class GetMeEvent {}

class FetchUserData extends GetMeEvent {}



class EditProfile extends GetMeEvent {
  final String email; // อีเมล
  // ชื่อผู้ใช้
  final String firstName; // ชื่อจริง
  final String lastName; // นามสกุล
  final String role; // บทบาท

  EditProfile({
    required this.email,
    
    required this.firstName,
    required this.lastName,
    required this.role,
  });
}
class UpdateUserData extends GetMeEvent {
  final UserModel user;

  UpdateUserData(this.user);
}

class ChangePasswordEvent extends GetMeEvent {
  final String currentPassword;
  final String newPassword;
  ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });
}

class UploadImageEvent extends GetMeEvent {
  final Uint8List imageData;
  UploadImageEvent(this.imageData);
}