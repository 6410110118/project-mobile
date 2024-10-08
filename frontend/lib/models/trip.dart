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

  // Constructor
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
  });

  // Factory constructor to create a Trip instance from JSON
  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'],
        tripName: json['name'],
        description: json['description'],
        address: json['address'],
        
        imageUrl: json['photo_reference'],
        starttime: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
        endtime: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
        role: json['role'] == 'Leader', // สมมติว่า role เป็น string "Leader" หรืออย่างอื่น
        isDone: json['isDone'] ?? false,
        doneTime: json['doneTime'] != null ? DateTime.parse(json['doneTime']) : null,
      );

  // Method to convert a Trip instance into JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': tripName,
        'description': description,
        'address': address,
        'photo_reference': imageUrl,
        'start_date': starttime?.toIso8601String(),
        'end_date': endtime?.toIso8601String(),
        'role': role,
        'isDone': isDone,
        'doneTime': doneTime?.toIso8601String(),
      };



  // Getter to check if the trip is late
  bool get isLate => endtime != null && DateTime.now().isAfter(endtime!);

  // Getter to check if the trip is upcoming
  bool get isUpcoming => starttime != null && DateTime.now().isBefore(starttime!);
}
