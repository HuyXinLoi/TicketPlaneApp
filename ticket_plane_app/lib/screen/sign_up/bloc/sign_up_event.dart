import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class SignupConfirmPasswordChanged extends SignupEvent {
  final String confirmPassword;

  const SignupConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object> get props => [confirmPassword];
}

class SignupEmailValidationChanged extends SignupEvent {
  final String email;

  const SignupEmailValidationChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class SignupPasswordValidationChanged extends SignupEvent {
  final String password;

  const SignupPasswordValidationChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class SignupConfirmPasswordValidationChanged extends SignupEvent {
  final String confirmPassword;
  final String password;

  const SignupConfirmPasswordValidationChanged(
      {required this.confirmPassword, required this.password});

  @override
  List<Object> get props => [confirmPassword, password];
}

class SignupSubmitted extends SignupEvent {}
