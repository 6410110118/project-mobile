class Person {
  final String firstname;
  final String lastname;
  final int userId;
  final int id;

  Person({
    required this.firstname,
    required this.lastname,
    required this.userId,
    required this.id,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      firstname: json['firstname'],
      lastname: json['lastname'],
      userId: json['user_id'],
      id: json['id'],
    );
  }
}
