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

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');
        if (userId == null || userId.isEmpty) {
          emit(const ProfileError(message: 'User not logged in.'));
          return;
        }

        Map<String, dynamic> updates = {};

        if (event.phoneNumber != null &&
            event.phoneNumber!.isNotEmpty &&
            RegExp(r'^[0-9]{10}$').hasMatch(event.phoneNumber!)) {
          updates['phoneNumber'] = event.phoneNumber;
        } else if (event.phoneNumber != null && event.phoneNumber!.isNotEmpty) {
          emit(const ProfileUpdateError(
              message: 'Please enter a valid 10-digit phone number.'));
          return;
        }

        if (event.address != null && event.address!.isNotEmpty) {
          updates['address'] = event.address;
        } else if (event.address != null && event.address!.isEmpty) {
          emit(const ProfileUpdateError(message: 'Please enter an address.'));
          return;
        }

        if (event.dateOfBirth != null) {
          updates['dateOfBirth'] = Timestamp.fromDate(event.dateOfBirth!);
        }

        if (event.name != null && event.name!.isNotEmpty) {
          updates['name'] = event.name;
        } else if (event.name != null && event.name!.isEmpty) {
          emit(const ProfileUpdateError(message: 'Please enter a name.'));
          return;
        }

        if (event.passport != null && event.passport!.isNotEmpty) {
          updates['passport'] = event.passport;
        } else if (event.passport != null && event.passport!.isEmpty) {
          emit(const ProfileUpdateError(message: 'Please enter a passport.'));
          return;
        }

        if (event.gender != null && event.gender!.isNotEmpty) {
          updates['gender'] = event.gender;
        } else if (event.gender != null && event.gender!.isEmpty) {
          emit(const ProfileUpdateError(message: 'Please select a gender.'));
          return;
        }
        
        // Update image URL if provided
        if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
          updates['urlImage'] = event.imageUrl;
        } else if (event.imageUrl != null && event.imageUrl!.isEmpty) {
          emit(const ProfileUpdateError(message: 'Please enter an image URL.'));
          return;
        }

        if (updates.isNotEmpty) {
          await _passengerRepository.updateUser(userId, updates);

          // Reload data from Firestore after successful update
          final results = await Future.wait([
            _passengerRepository.getUserById(userId),
            _passengerRepository.getUserData(userId),
          ]);

          final user = results[0] as Passenger?;
          final userData = results[1] as Map<String, dynamic>?;

          if (user != null && userData != null) {
            _cachedUserData = {
              ...user.toJson(),
              ...?userData,
            };
          } else {
            _cachedUserData = null; // Or handle error appropriately
          }

          emit(ProfileLoaded(userData: _cachedUserData!));
        } else {
          emit(ProfileLoaded(userData: _cachedUserData!));
        }
      } catch (e) {
        emit(ProfileError(message: 'Failed to update profile: $e'));
      }
    });

    // on<ChangeAvatar>((event, emit) async {
    //   emit(ProfileLoading());
    //   try {
    //     final prefs = await SharedPreferences.getInstance();
    //     final userId = prefs.getString('userId');

    //     if (userId != null) {
    //       print("ProfileBloc: Calling updatePassengerAvatar");

    //       await _passengerRepository.updatePassengerAvatar(
    //           userId, event.newAvatarUrl);

    //       print("ProfileBloc: updatePassengerAvatar completed");
    //       emit(ProfileChangeAvatarSuccess());

    //       // Reload profile to get the updated data from Firestore:
    //       add(LoadProfile(userId: userId));
    //     } else {
    //       emit(ProfileChangeAvatarFailure('User ID not found.'));
    //     }
    //   } catch (e) {
    //     emit(ProfileChangeAvatarFailure(e.toString()));
    //   }
    // });
    on<ClearProfileCache>(_onClearProfileCache);
  }

  Future<void> _onClearProfileCache(
      ClearProfileCache event, Emitter<ProfileState> emit) async {
    _cachedUserData = null; // Clear the cache
    emit(ProfileInitial()); // Emit ProfileInitial to reset the state and trigger a reload if LoadProfile is added next
  }
}