import 'package:frontend/models/groups.dart';

abstract class GroupEvent {}

class FetchGroupEvent extends GroupEvent {
  
  FetchGroupEvent();
}
// Event สำหรับสร้างกลุ่ม
class CreateGroupEvent extends GroupEvent {
  final Group newGroup;

  CreateGroupEvent({required this.newGroup});
}


