class ItemPeople {
  final int id;
  final int itemId;
  final int peopleId;

  // Constructor
  ItemPeople({
    required this.id,
    required this.itemId,
    required this.peopleId,
  });

  // ฟังก์ชันสำหรับแปลง JSON เป็นโมเดล
  factory ItemPeople.fromJson(Map<String, dynamic> json) {
    return ItemPeople(
      id: json['id'] as int,
      itemId: json['item_id'] as int,
      peopleId: json['people_id'] as int,
    );
  }

  // ฟังก์ชันสำหรับแปลงโมเดลกลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_id': itemId,
      'people_id': peopleId,
    };
  }
}
