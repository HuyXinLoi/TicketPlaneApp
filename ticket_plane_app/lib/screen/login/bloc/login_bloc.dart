import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginBloc() : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginWithGooglePressed>(_onLoginWithGooglePressed);
    on<LoginWithFacebookPressed>(_onLoginWithFacebookPressed);
    on<LoginWithApplePressed>(_onLoginWithApplePressed);
    on<LoginEmailValidationChanged>(_onEmailValidationChanged);
    on<LoginPasswordValidationChanged>(_onPasswordValidationChanged);
    on<LogOut>(_onLogOut);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, status: LoginStates.initial));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password, status: LoginStates.initial));
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    final isEmailValid = _validateEmail(state.email);
    final isPasswordValid = _validatePassword(state.password);
    if (!isEmailValid) {
      emit(state.copyWith(
        isEmailValid: false,
        status: LoginStates.failure,
        errorMessage: 'Email không đúng định dạng. Vui lòng thử lại!',
      ));
      return;
    }
    if (!isPasswordValid) {
      emit(state.copyWith(
        isPasswordValid: false,
        status: LoginStates.failure,
        errorMessage: 'Vui lòng nhập mật khẩu!',
      ));
      return;
    }
    emit(state.copyWith(status: LoginStates.loading));
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userCredential.user!.uid);
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: LoginStates.success));
    } on FirebaseAuthException catch (e) {
      String errorMessage =
          'Tài khoản hoặc mật khẩu không chính xác. Vui lòng thử lại!';
      if (e.code == 'wrong-password') {
        errorMessage = 'Sai mật khẩu. Vui lòng thử lại!';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'Tài khoản không tồn tại. Vui lòng kiểm tra email!';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Tài khoản bị khóa tạm thời. Vui lòng thử lại sau!';
      }

      emit(state.copyWith(
        status: LoginStates.failure,
        errorMessage: errorMessage,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStates.failure,
        errorMessage: 'Có lỗi xảy ra. Vui lòng thử lại sau!',
      ));
    }
  }

  Future<void> _onLoginWithGooglePressed(
      LoginWithGooglePressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStates.loading));
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(state.copyWith(
            status: LoginStates.failure,
            errorMessage: 'Google Sign-In cancelled.'));
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      await _firestore
          .collection('passengers')
          .doc(userCredential.user!.uid)
          .set({
        'DOB': FieldValue.serverTimestamp(),
        'DiaChi': '',
        'Email': userCredential.user!.email,
        'GioiTinh': 0,
        'Name': userCredential.user!.displayName,
        'PassPort': '',
        'UserId': userCredential.user!.uid,
        'urlImage': userCredential.user!.photoURL,
      }, SetOptions(merge: true));

      emit(state.copyWith(status: LoginStates.success));
      event.context.go('/nav');
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: LoginStates.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStates.failure,
        errorMessage: 'Google Sign-In failed.',
      ));
    }
  }

  Future<void> _onLoginWithFacebookPressed(
      LoginWithFacebookPressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStates.loading));
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final userData = await FacebookAuth.instance.getUserData();

        await _firestore
            .collection('passengers')
            .doc(userCredential.user!.uid)
            .set({
          'DOB': FieldValue.serverTimestamp(),
          'DiaChi': '',
          'Email': userData['email'],
          'GioiTinh': 0,
          'Name': userData['name'],
          'PassPort': '',
          'UserId': userCredential.user!.uid,
          'urlImage': userData['picture']['data']['url'],
        }, SetOptions(merge: true));

        emit(state.copyWith(status: LoginStates.success));
        event.context.go('/nav');
      } else {
        emit(state.copyWith(
          status: LoginStates.failure,
          errorMessage: 'Facebook Login cancelled.',
        ));
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: LoginStates.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStates.failure,
        errorMessage: 'Facebook Login failed.',
      ));
    }
  }

  Future<void> _onLoginWithApplePressed(
      LoginWithApplePressed event, Emitter<LoginState> emit) async {}

  void _onEmailValidationChanged(
      LoginEmailValidationChanged event, Emitter<LoginState> emit) {
    final isEmailValid = _validateEmail(event.email);
    emit(state.copyWith(isEmailValid: isEmailValid));
  }

  void _onPasswordValidationChanged(
      LoginPasswordValidationChanged event, Emitter<LoginState> emit) {
    final isPasswordValid = _validatePassword(event.password);
    emit(state.copyWith(isPasswordValid: isPasswordValid));
  }

  void _onLogOut(LogOut event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStates.initial));
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty;
  }
}
