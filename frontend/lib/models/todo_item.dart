class TodoItem {
  String task;
  bool isCompleted;

  TodoItem({required this.task, this.isCompleted = false});

  // เพิ่มเมธอด fromJson สำหรับการแปลงจาก JSON เป็น Object
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      task: json['task'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // เพิ่มเมธอด toJson สำหรับการแปลงจาก Object เป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'isCompleted': isCompleted,
    };
  }
}
