class Group {
  final String? name;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? imageUrl; // Nullable เนื่องจากอาจไม่มีรูป

  Group({
    required this.name,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'] ?? 'Unknown Name',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    
      'name': name,
     'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'image_url': imageUrl,
    
  };
}
