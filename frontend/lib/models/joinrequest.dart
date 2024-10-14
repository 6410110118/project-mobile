class JoinRequest {
  final int id;
  final int peopleId;
  final int itemId;
  final String status;
  final String? requestMessage;
  final DateTime updatedAt;

  JoinRequest({
    required this.id,
    required this.peopleId,
    required this.itemId,
    required this.status,
    this.requestMessage,
    required this.updatedAt,
  });

  // Factory constructor to create a JoinRequest from JSON data
  factory JoinRequest.fromJson(Map<String, dynamic> json) {
    return JoinRequest(
      id: json['id'],
      peopleId: json['people_id'],
      itemId: json['item_id'],
      status: json['status'],
      requestMessage: json['request_message'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a JoinRequest object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'people_id': peopleId,
      'item_id': itemId,
      'status': status,
      'request_message': requestMessage,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
