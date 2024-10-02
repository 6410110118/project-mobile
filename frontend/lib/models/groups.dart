class Group {
  int? id;
  String? name;


  Group({
    this.id,
    this.name,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

}