import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {}

class LoginWithGooglePressed extends LoginEvent {
  final BuildContext context;
  const LoginWithGooglePressed({required this.context});
  @override
  List<Object> get props => [context];
}

class LoginWithFacebookPressed extends LoginEvent {
  final BuildContext context;
  const LoginWithFacebookPressed({required this.context});
  @override
  List<Object> get props => [context];
}

class LoginWithApplePressed extends LoginEvent {}

class LoginEmailValidationChanged extends LoginEvent {
  final String email;

  const LoginEmailValidationChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordValidationChanged extends LoginEvent {
  final String password;

  const LoginPasswordValidationChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class LogOut extends LoginEvent {}
