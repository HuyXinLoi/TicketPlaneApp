import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bloc_event.dart';
part 'bloc_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(ProfileLoggedOut());
    });
  }
}
