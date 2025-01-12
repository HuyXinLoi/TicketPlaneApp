import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LogoutButtonPressed extends ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ChangePasswordPressed extends ProfileEvent {
  final String oldPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangePasswordPressed({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  @override
  List<Object> get props => [oldPassword, newPassword, confirmNewPassword];
}

class ResetProfileState extends ProfileEvent {}

// class LoadUserProfile extends ProfileEvent {}


// Thêm event ShowSnackBar
class ShowSnackBar extends ProfileEvent {
  final String message;
  final bool isError; // true nếu là lỗi, false nếu là thông báo thành công

  const ShowSnackBar({required this.message, this.isError = false});

  @override
  List<Object> get props => [message, isError];
}