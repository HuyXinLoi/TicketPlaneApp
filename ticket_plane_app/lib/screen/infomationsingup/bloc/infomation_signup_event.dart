part of 'infomation_signup_bloc.dart';

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object?> get props => [];
}

class UserInfoNameChanged extends UserInfoEvent {
  final String name;

  const UserInfoNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class UserInfoPhoneNumberChanged extends UserInfoEvent {
  final String phoneNumber;

  const UserInfoPhoneNumberChanged({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class UserInfoAddressChanged extends UserInfoEvent {
  final String address;

  const UserInfoAddressChanged({required this.address});

  @override
  List<Object?> get props => [address];
}

class UserInfoGenderChanged extends UserInfoEvent {
  final String gender;

  const UserInfoGenderChanged({required this.gender});

  @override
  List<Object?> get props => [gender];
}

class UserInfoPassportChanged extends UserInfoEvent {
  final String passport;

  const UserInfoPassportChanged({required this.passport});

  @override
  List<Object?> get props => [passport];
}

class UserInfoDateOfBirthChanged extends UserInfoEvent {
  final DateTime dateOfBirth;

  const UserInfoDateOfBirthChanged({required this.dateOfBirth});

  @override
  List<Object?> get props => [dateOfBirth];
}

class UserInfoSubmitted extends UserInfoEvent {}
