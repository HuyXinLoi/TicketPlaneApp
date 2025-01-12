import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ticket_plane_app/screen/profile/auth_repository.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';

import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final PassengerRepository _passengerRepository;

  ProfileBloc(
      {required AuthRepository authRepository,
      required PassengerRepository passengerRepository})
      : _authRepository = authRepository,
        _passengerRepository = passengerRepository,
        super(ProfileInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      await _authRepository.signOut();
      emit(ProfileLoggedOut());
      emit(ProfileInitial());
    });

    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await _passengerRepository.getUserById(event.userId);
        final userData =
            await _passengerRepository.getUserData(event.userId);

        if (user != null && userData != null) {
          final combinedUserData = {
            ...user.toJson(),
            ...?userData,
          };
          emit(ProfileLoaded(userData: combinedUserData));
        } else {
          emit(const ProfileError(message: 'User not found.'));
        }
      } catch (e) {
        emit(ProfileError(message: 'Error loading profile: $e'));
      }
    });
  }
}