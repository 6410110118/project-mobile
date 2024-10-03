class Group {
  final String name;

  Group({
    required this.name,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'],
    );
  }
}
