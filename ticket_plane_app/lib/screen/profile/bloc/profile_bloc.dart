import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/login/data/user.dart';
import 'package:ticket_plane_app/screen/profile/auth_repository.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';
import 'package:ticket_plane_app/screen/profile/passenger.dart';
import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final PassengerRepository _passengerRepository;
  Map<String, dynamic>? _cachedUserData;

  ProfileBloc({
    required AuthRepository authRepository,
    required PassengerRepository passengerRepository,
  })  : _authRepository = authRepository,
        _passengerRepository = passengerRepository,
        super(ProfileInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      print("ProfileBloc - LogoutButtonPressed received");
      await _authRepository.signOut();
      final prefs = await SharedPreferences.getInstance();
      final userId = await prefs.getString('userId');
      await prefs.setString('biologic', userId!);
      await prefs.remove('userId');

      _cachedUserData = null;
      print("ProfileBloc - Emitting ProfileLoggedOut");
      emit(ProfileLoggedOut());
      print("ProfileBloc - Emitting ProfileInitial");
      emit(ProfileInitial());
    });

    on<LoadProfile>((event, emit) async {
      print("ProfileBloc - LoadProfile received for userId: ${event.userId}");
      if (_cachedUserData != null) {
        print("ProfileBloc - Using cached data");
        emit(ProfileLoaded(userData: _cachedUserData!));
        return;
      }

      print("ProfileBloc - Fetching data from repository");
      emit(ProfileLoading());
      try {
        final results = await Future.wait([
          _passengerRepository.getUserById(event.userId),
          _passengerRepository.getUserData(event.userId),
        ]);

        final user = results[0] as Passenger?;
        final userData = results[1] as Map<String, dynamic>?;

        if (user != null && userData != null) {
          final combinedUserData = {
            ...user.toJson(),
            ...?userData,
          };
          _cachedUserData = combinedUserData;
          print("ProfileBloc - Emitting ProfileLoaded");
          emit(ProfileLoaded(userData: combinedUserData));
        } else {
          print("ProfileBloc - User not found, emitting ProfileError");
          emit(const ProfileError(message: 'User not found.'));
        }
      } catch (e) {
        print("ProfileBloc - Error loading profile: $e");
        emit(ProfileError(message: 'Error loading profile: $e'));
      }
    });

    on<ChangePasswordPressed>((event, emit) async {
      print("ProfileBloc - ChangePasswordPressed received");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        emit(ProfileChangePasswordLoading());
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

        if (userId == null || userId.isEmpty) {
          emit(const ProfileChangePasswordFailure(
              message: 'User not logged in.'));
          return;
        }

        final userData = await _passengerRepository.getUserData(userId);
        final userEmail = userData?['email'];

        if (userEmail == null || userEmail.isEmpty) {
          emit(const ProfileChangePasswordFailure(message: 'Email not found.'));
          return;
        }

        AuthCredential credential = EmailAuthProvider.credential(
            email: userEmail, password: event.oldPassword);

        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);

        if (event.newPassword.length < 6) {
          emit(const ProfileChangePasswordFailure(
              message: 'New password must be at least 6 characters.'));
          return;
        }

        if (event.newPassword != event.confirmNewPassword) {
          emit(const ProfileChangePasswordFailure(
              message: 'New passwords do not match.'));
          return;
        }

        await FirebaseAuth.instance.currentUser!
            .updatePassword(event.newPassword);

        emit(ProfileChangePasswordSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          emit(const ProfileIncorrectOldPassword());
        } else {
          emit(ProfileChangePasswordFailure(
              message: 'Mật khẩu cũ không khớp!: ${e.message}'));
        }
      } catch (e) {
        emit(ProfileChangePasswordFailure(message: 'Unexpected error: $e'));
      }
    });

    on<ShowSnackBar>((event, emit) {
      print("ProfileBloc - ShowSnackBar event received (no state change)");
      // No state change needed, just a way to trigger a SnackBar
    });

    on<ResetProfileState>((event, emit) {
      print(
          "ProfileBloc - ResetProfileState received, emitting ProfileInitial");
      emit(ProfileInitial());
    });

    // on<UpdateProfilePicture>((event, emit) async {
    //   try {
    //     final prefs = await SharedPreferences.getInstance();
    //     final userId = prefs.getString('userId');

    //     if (userId == null || userId.isEmpty) {
    //       emit(const ProfileError(message: 'User not logged in.'));
    //       return;
    //     }

    //     // Upload the image to Firebase Storage
    //     final storageRef = FirebaseStorage.instance
    //         .ref()
    //         .child('user_images')
    //         .child('$userId.jpg');
    //     final file = File(event.imagePath);
    //     final uploadTask = storageRef.putFile(file);
    //     final snapshot = await uploadTask.whenComplete(() {});
    //     final downloadUrl = await snapshot.ref.getDownloadURL();

    //     // Update the user's profile in Firestore
    //     await _passengerRepository.updateUser(userId, {'urlImage': downloadUrl});

    //     // Update the cached user data and emit a new state
    //     _cachedUserData?['urlImage'] = downloadUrl;
    //     emit(ProfileLoaded(userData: _cachedUserData!));
    //   } catch (e) {
    //     emit(ProfileError(message: 'Failed to update profile picture: $e'));
    //   }
    // });
    on<UpdatePhoneNumber>((event, emit) async {
      emit(ProfileLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');
        if (userId == null || userId.isEmpty) {
          emit(const ProfileError(message: 'User not logged in.'));
          return;
        }

        // Validation: Check for empty or invalid phone number
        if (event.phoneNumber.isEmpty) {
          emit(const ProfileUpdateError(
              message: 'Please enter a phone number.'));
          return;
        }
        if (!RegExp(r'^[0-9]{10}$').hasMatch(event.phoneNumber)) {
          emit(const ProfileUpdateError(
              message: 'Please enter a valid 10-digit phone number.'));
          return;
        }

        await _passengerRepository
            .updateUser(userId, {'phoneNumber': event.phoneNumber});
        _cachedUserData?['phoneNumber'] = event.phoneNumber;
        emit(ProfileLoaded(userData: _cachedUserData!));
      } catch (e) {
        emit(ProfileError(message: 'Failed to update phone number: $e'));
      }
    });

    on<UpdateAddress>((event, emit) async {
      emit(ProfileLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');
        if (userId == null || userId.isEmpty) {
          emit(const ProfileError(message: 'User not logged in.'));
          return;
        }

        // Validation: Check for empty address
        if (event.address.isEmpty) {
          emit(const ProfileUpdateError(message: 'Please enter an address.'));
          return;
        }

        await _passengerRepository
            .updateUser(userId, {'address': event.address});
        _cachedUserData?['address'] = event.address;
        emit(ProfileLoaded(userData: _cachedUserData!));
      } catch (e) {
        emit(ProfileError(message: 'Failed to update address: $e'));
      }
    });

    on<UpdateDateOfBirth>((event, emit) async {
      emit(ProfileLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');
        if (userId == null || userId.isEmpty) {
          emit(const ProfileError(message: 'User not logged in.'));
          return;
        }

        await _passengerRepository.updateUser(
            userId, {'dateOfBirth': Timestamp.fromDate(event.dateOfBirth)});
        _cachedUserData?['dateOfBirth'] = Timestamp.fromDate(event.dateOfBirth);
        emit(ProfileLoaded(userData: _cachedUserData!));
      } catch (e) {
        emit(ProfileError(message: 'Failed to update date of birth: $e'));
      }
    });
  }
}
