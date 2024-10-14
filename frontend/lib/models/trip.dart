import '../models/todo_item.dart'; // import TodoItem จากที่เดียวกัน

class Trip {
  int? id;
  String? tripName;
  String? description;
  String? address;
  String? imageUrl;
  DateTime? starttime;
  DateTime? endtime;
  bool? role;
  bool? isDone;
  DateTime? doneTime;
  List<TodoItem> todoList;

  Trip({
    this.id,
    this.tripName,
    this.description,
    this.address,
    this.imageUrl,
    this.starttime,
    this.endtime,
    this.role = false,
    this.isDone = false,
    this.doneTime,
    this.todoList = const [],
  });

// JSON -> Object
factory Trip.fromJson(Map<String, dynamic> json) => Trip(
      id: json['id'],
      tripName: json['name'],
      description: json['description'],
      address: json['address'],
      imageUrl: json['photo_reference'],
      starttime: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endtime: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      role: json['role'] == 'Leader',
      isDone: json['isDone'] ?? false,
      doneTime: json['doneTime'] != null ? DateTime.parse(json['doneTime']) : null,
      todoList: json['todoList'] != null
          ? (json['todoList'] as List)
              .map((task) => TodoItem(task: task, isCompleted: false))
              .toList()
          : [], // แก้ไขตรงนี้ ถ้า todoList เป็น null ให้ใช้ลิสต์ว่าง
    );

  // Object -> JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': tripName,
        'description': description,
        'address': address,
        'photo_reference': imageUrl,
        'start_date': starttime?.toIso8601String(),
        'end_date': endtime?.toIso8601String(),
        'role': role == true ? "Leader" : "Participant",
        'isDone': isDone,
        'doneTime': doneTime?.toIso8601String(),
        'todoList': todoList.map((todoItem) => todoItem.task).toList(),
      };

  bool get isLate => endtime != null && DateTime.now().isAfter(endtime!);

  bool get isUpcoming => starttime != null && DateTime.now().isBefore(starttime!);
}
