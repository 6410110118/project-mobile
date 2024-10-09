import 'dart:convert';
import 'dart:typed_data';

class UserModel {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? role;
  
  final String? email;
  
  final int? id;
  
  final DateTime? lastLoginDate;
  final DateTime? registerDate;

  final Uint8List? imageData;

  UserModel({
    this.username,
    this.firstName,
    this.lastName,
    this.role,
    
    this.email,
    
    this.id,
    
    this.lastLoginDate,
    this.registerDate,
    this.imageData,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      
      email: json['email'],
      
      id: json['id'],
      
      lastLoginDate: json['last_login_date'] != null
          ? DateTime.parse(json['last_login_date'])
          : null,
      registerDate: json['register_date'] != null
          ? DateTime.parse(json['register_date'])
          : null,
      imageData:
          json['imageData'] != null ? base64Decode(json['imageData']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      
      'email': email,
      
      'id': id,
    };
  }
}