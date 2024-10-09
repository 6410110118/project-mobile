



import 'package:frontend/models/user.dart';

abstract class GetMeState {}

class GetMeInitial extends GetMeState {}

class GetMeLoading extends GetMeState {}

class GetMeLoaded extends GetMeState {
  final UserModel user;

  GetMeLoaded(this.user);
}

class GetMeError extends GetMeState {
  final String message;

  GetMeError(this.message);
}




class ProfileEdited extends GetMeState {}

class ProfileEditError extends GetMeState {
  final String message;

  ProfileEditError(this.message);

}
class ProfileEditerSuccess extends GetMeState {
  final String message;

  ProfileEditerSuccess(this.message);
}
class ChangePasswordLoading extends GetMeState {}

class ChangePasswordSuccess extends GetMeState {}
class ChangePasswordFailure extends GetMeState {
  final String error;
  ChangePasswordFailure(this.error);
}

class ImageUploadLoading extends GetMeState {}
class ImageUploaded extends GetMeState {}

class ImageUploadSuccess extends GetMeState {
  final String message;
  ImageUploadSuccess(this.message);
}

class ImageUploadFailure extends GetMeState {
  final String error;
  ImageUploadFailure(this.error);
}


