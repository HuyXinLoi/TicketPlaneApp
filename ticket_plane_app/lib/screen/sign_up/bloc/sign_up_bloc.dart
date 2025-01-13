import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/sign_up/bloc/sign_up_event.dart';
import 'package:ticket_plane_app/screen/sign_up/bloc/sign_up_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignupBloc() : super(SignupState()) {
    on<SignupEmailChanged>(_onEmailChanged);
    on<SignupPasswordChanged>(_onPasswordChanged);
    on<SignupConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupEmailValidationChanged>(_onEmailValidationChanged);
    on<SignupPasswordValidationChanged>(_onPasswordValidationChanged);
    on<SignupConfirmPasswordValidationChanged>(
        _onConfirmPasswordValidationChanged);
    on<SignupSubmitted>(_onSubmitted);
    on<LogOutSignUp>(_onLogOut);
  }

  void _onEmailChanged(SignupEmailChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(email: event.email, status: SignupStatus.initial));
  }

  void _onPasswordChanged(
      SignupPasswordChanged event, Emitter<SignupState> emit) {
    emit(
        state.copyWith(password: event.password, status: SignupStatus.initial));
  }

  void _onConfirmPasswordChanged(
      SignupConfirmPasswordChanged event, Emitter<SignupState> emit) {
    emit(state.copyWith(
        confirmPassword: event.confirmPassword, status: SignupStatus.initial));
  }

  void _onEmailValidationChanged(
      SignupEmailValidationChanged event, Emitter<SignupState> emit) {
    final isEmailValid = _validateEmail(event.email);
    emit(state.copyWith(
        isEmailValid: isEmailValid, status: SignupStatus.initial));
  }

  void _onPasswordValidationChanged(
      SignupPasswordValidationChanged event, Emitter<SignupState> emit) {
    final isPasswordValid = _validatePassword(event.password);
    emit(state.copyWith(
        isPasswordValid: isPasswordValid, status: SignupStatus.initial));
  }

  void _onConfirmPasswordValidationChanged(
      SignupConfirmPasswordValidationChanged event, Emitter<SignupState> emit) {
    final isConfirmPasswordValid =
        _validateConfirmPassword(event.confirmPassword, event.password);
    emit(state.copyWith(
        isConfirmPasswordValid: isConfirmPasswordValid,
        status: SignupStatus.initial));
  }

  Future<void> _onSubmitted(
      SignupSubmitted event, Emitter<SignupState> emit) async {
    final isEmailValid = _validateEmail(state.email);
    final isPasswordValid = _validatePassword(state.password);
    final isComfirmPasswordValid =
        _validateConfirmPassword(state.confirmPassword, state.password);

    if (!isEmailValid) {
      emit(state.copyWith(
        isEmailValid: false,
        status: SignupStatus.failure,
        errorMessage: 'Vui lòng nhập đúng định dạng email dùm cái :))!',
      ));
      return;
    }

    if (!isPasswordValid) {
      emit(state.copyWith(
        isEmailValid: false,
        status: SignupStatus.failure,
        errorMessage: 'Vui lòng nhập mật khẩu dài hơn 6 ký tự!',
      ));
      return;
    }
    if (!isComfirmPasswordValid) {
      emit(state.copyWith(
        isEmailValid: false,
        status: SignupStatus.failure,
        errorMessage: 'Vui lòng nhập mật khẩu trùng nhau giùm :))!',
      ));
      return;
    }

    if (isEmailValid && isPasswordValid && isComfirmPasswordValid) {
      emit(state.copyWith(status: SignupStatus.loading));
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
                email: state.email, password: state.password);
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': state.email,
          'password': state.password,
          'userId': userCredential.user!.uid,
        });
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.setString('userId', userCredential.user!.uid);
        final email = prefs.setString('email', userCredential.user!.email!);
        emit(state.copyWith(
            status: SignupStatus.success, userId: userCredential.user!.uid));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Tài khoản này đã có người đăng ký!'));
      } catch (_) {
        emit(state.copyWith(status: SignupStatus.failure));
      }
    }
  }

  void _onLogOut(LogOutSignUp event, Emitter<SignupState> emit) {
    emit(state.copyWith(status: SignupStatus.initial));
  }

  bool _validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validateConfirmPassword(String confirmPassword, String password) {
    return confirmPassword == password;
  }
}
