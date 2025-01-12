import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  final Function(String, bool)? onPasswordChanged; // Thêm callback vào đây

  const ProfileState({this.onPasswordChanged});

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;

  const ProfileLoaded({required this.userData,  Function(String, bool)? onPasswordChanged}) : super(onPasswordChanged: onPasswordChanged);

  @override
  List<Object?> get props => [userData];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message, Function(String, bool)? onPasswordChanged}) : super(onPasswordChanged: onPasswordChanged);

  @override
  List<Object?> get props => [message];
}

class ProfileLoggedOut extends ProfileState {}

class ProfileChangePasswordLoading extends ProfileState {}

class ProfileChangePasswordSuccess extends ProfileState {}
// class ProfileFailure extends ProfileState {
//   final String message;

//   const ProfileFailure({required this.message});

//   @override
//   List<Object> get props => [message];
// }
class ProfileChangePasswordFailure extends ProfileState {
  final String message;

  const ProfileChangePasswordFailure({required this.message, Function(String, bool)? onPasswordChanged}) : super(onPasswordChanged: onPasswordChanged);

  @override
  List<Object?> get props => [message];
}