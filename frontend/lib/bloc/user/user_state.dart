



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