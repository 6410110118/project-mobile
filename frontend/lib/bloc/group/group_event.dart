

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




class AddPersonToGroupEvent extends GroupEvent {
  final int groupId;
  final int peopleId;

  AddPersonToGroupEvent({required this.groupId, required this.peopleId});
}

class FetchGroupPeople extends GroupEvent {
  final int groupId;

  FetchGroupPeople(this.groupId);
}
