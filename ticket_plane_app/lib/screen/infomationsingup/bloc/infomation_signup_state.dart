part of 'infomation_signup_bloc.dart';

enum UserInfoStatus { initial, loading, success, failure }

class UserInfoState extends Equatable {
  final String name;
  final String phoneNumber;
  final String address;
  final String gender;
  final String passport;
  final DateTime dateOfBirth;
  final UserInfoStatus status;
  final String? errorMessage;

  UserInfoState({
    this.name = '',
    this.phoneNumber = '',
    this.address = '',
    this.gender = '',
    this.passport = '',
    DateTime? dateOfBirth,
    this.status = UserInfoStatus.initial,
    this.errorMessage,
  }) : this.dateOfBirth = dateOfBirth ?? DateTime.now();

  UserInfoState copyWith({
    String? name,
    String? phoneNumber,
    String? address,
    String? gender,
    String? passport,
    DateTime? dateOfBirth,
    UserInfoStatus? status,
    String? errorMessage,
  }) {
    return UserInfoState(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      passport: passport ?? this.passport,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        phoneNumber,
        address,
        gender,
        passport,
        dateOfBirth,
        status,
        errorMessage,
      ];
}
