import 'package:cloud_firestore/cloud_firestore.dart';

class Passenger {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String passport;
  final String address;
  final DateTime dateOfBirth;
  final String urlImage;
  final String gender;

  Passenger({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.passport,
    required this.address,
    required this.dateOfBirth,
    required this.urlImage,
    required this.gender,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      userId: json['userId'],
      name: json['name'],
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      passport: json['passport'],
      address: json['address'],
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      urlImage: json['urlImage'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'passport': passport,
      'address': address,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'urlImage': urlImage,
      'gender': gender,
    };
  }
}