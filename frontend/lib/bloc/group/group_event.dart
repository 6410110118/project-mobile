

abstract class GroupEvent {}

class FetchGroupEvent extends GroupEvent {
  
  FetchGroupEvent();
}
// Event สำหรับสร้างกลุ่ม
class AddGroupEvent extends GroupEvent {
  final String name;
  
  final DateTime? startDate;
  final DateTime? endDate;

  AddGroupEvent({
    required this.name,
    
    this.startDate,
    this.endDate,
  });
}


