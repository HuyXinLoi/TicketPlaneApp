import 'package:equatable/equatable.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;
  final SignupStatus status;
  final String? errorMessage;
  final String? userId;

  const SignupState(
      {this.email = '',
      this.password = '',
      this.confirmPassword = '',
      this.isEmailValid = true,
      this.isPasswordValid = true,
      this.isConfirmPasswordValid = true,
      this.status = SignupStatus.initial,
      this.errorMessage,
      this.userId = ''});

  SignupState copyWith(
      {String? email,
      String? password,
      String? confirmPassword,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isConfirmPasswordValid,
      SignupStatus? status,
      String? errorMessage,
      String? userId}) {
    return SignupState(
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isConfirmPasswordValid:
            isConfirmPasswordValid ?? this.isConfirmPasswordValid,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        userId: userId ?? '');
  }

  @override
  List<Object?> get props => [
        email,
        password,
        confirmPassword,
        isEmailValid,
        isPasswordValid,
        isConfirmPasswordValid,
        status,
        errorMessage,
        userId
      ];
}
