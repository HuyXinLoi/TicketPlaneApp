part of 'bloc_bloc.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LogoutButtonPressed extends ProfileEvent {}

