import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailSubmitted>(_onForgotPasswordEmailSubmitted);
  }

  Future<void> _onForgotPasswordEmailSubmitted(
    ForgotPasswordEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final isEmailValid = _validateEmail(event.email);
    emit(ForgotPasswordLoading());

    if (event.email.isEmpty) {
      emit(ForgotPasswordFailure(error: 'Không Có Email Mà Đòi Gửi :)?'));
    }

    if (!isEmailValid) {
      emit(ForgotPasswordFailure(
          error: 'Vui Lòng Nhập Đúng Định Dạng Email :)?'));
      return;
    }

    try {
      final email = event.email;
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        emit(const ForgotPasswordFailure(
            error: 'Tài Khoản Này Chưa Được Đăng Ký'));
        return;
      }
      await _auth.sendPasswordResetEmail(email: email);
      emit(ForgotPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ForgotPasswordFailure(error: e.message ?? 'Firebase error.'));
    } catch (e) {
      emit(ForgotPasswordFailure(error: e.toString()));
    }
  }
}

bool _validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
