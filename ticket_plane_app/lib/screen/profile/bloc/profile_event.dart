import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => []; // Use List<Object?> instead of List<Object>
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

class ShowSnackBar extends ProfileEvent {
  final String message;
  final bool isError; // true if error, false if success

  const ShowSnackBar({required this.message, this.isError = false});

  @override
  List<Object> get props => [message, isError];
}

// Note: UpdateProfilePicture is removed as we are now handling image updates via URL
// If you still need to handle local file uploads, you can re-add it.

class ChangeAvatar extends ProfileEvent {
  final String newAvatarUrl;

  const ChangeAvatar({required this.newAvatarUrl});

  @override
  List<Object> get props => [newAvatarUrl];
}

class ClearProfileCache extends ProfileEvent {
  const ClearProfileCache();
}

class UpdateProfile extends ProfileEvent {
  final String? phoneNumber;
  final String? address;
  final DateTime? dateOfBirth;
  final String? name;
  final String? passport;
  final String? gender;
  final String? imageUrl; // Add imageUrl

  const UpdateProfile({
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.name,
    this.passport,
    this.gender,
    this.imageUrl, // Add imageUrl
  });

  @override
  List<Object?> get props => [phoneNumber, address, dateOfBirth, name, passport, gender, imageUrl]; // Add imageUrl
}