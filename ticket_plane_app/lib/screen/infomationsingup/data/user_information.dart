import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String name;
  final String phoneNumber;
  final String address;
  final String gender;
  final String passport;
  final DateTime dateOfBirth;
  final String? urlImage;
  final String userId;
  final String? email;

  UserInfo(
      {required this.name,
      required this.phoneNumber,
      required this.address,
      required this.gender,
      required this.passport,
      required this.dateOfBirth,
      required this.urlImage,
      required this.userId,
      required this.email});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'gender': gender,
      'passport': passport,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'urlImage': urlImage,
      'userId': userId,
      'email': email
    };
  }

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
        name: map['name'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        address: map['address'] ?? '',
        gender: map['gender'] ?? '',
        passport: map['passport'] ?? '',
        dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
        urlImage: map['urlImage'] ?? '',
        userId: map['userId'] ?? '',
        email: map['email'] ?? '');
  }
}
