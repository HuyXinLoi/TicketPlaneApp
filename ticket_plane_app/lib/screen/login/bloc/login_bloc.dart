import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    // Chỉ cập nhật email mà không thực hiện logic khác
    emit(state.copyWith(email: event.email, status: LoginStates.initial));
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    // Chỉ cập nhật password mà không thực hiện logic khác
    emit(state.copyWith(password: event.password, status: LoginStates.initial));
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    final isEmailValid = _validateEmail(state.email);
    final isPasswordValid = _validatePassword(state.password);

    // Nếu email không hợp lệ, gán lỗi tùy chỉnh
    if (!isEmailValid) {
      emit(state.copyWith(
        isEmailValid: false,
        status: LoginStates.failure,
        errorMessage: 'Email không đúng định dạng. Vui lòng thử lại!',
      ));
      return;
    }

    // Nếu mật khẩu không hợp lệ, gán lỗi tùy chỉnh
    if (!isPasswordValid) {
      emit(state.copyWith(
        isPasswordValid: false,
        status: LoginStates.failure,
        errorMessage: 'Vui lòng nhập mật khẩu!',
      ));
      return;
    }

    // Sau khi kiểm tra hợp lệ, gọi Firebase
    emit(state.copyWith(status: LoginStates.loading));
    try {
      await _auth.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.setString('username', state.email);
      final savedPassword = prefs.setString('password', state.password);
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
      // 1. Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign in
        emit(state.copyWith(
            status: LoginStates.failure,
            errorMessage: 'Google Sign-In cancelled.'));
        return;
      }

      // 2. Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // 5. Save user info to Firestore in the "passengers" collection
      await _firestore
          .collection('passengers')
          .doc(userCredential.user!.uid)
          .set({
        'DOB': FieldValue
            .serverTimestamp(), // Placeholder for now, you should get this from user input later
        'DiaChi': '', // Placeholder, get this from user input
        'Email': userCredential.user!.email,
        'GioiTinh': 0, // Placeholder, consider using an enum or boolean
        'Name': userCredential.user!.displayName,
        'PassPort': '', // Placeholder, get this from user input
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
      // 1. Trigger Facebook Login flow
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        // 2. Get access token
        final AccessToken accessToken = result.accessToken!;
        // 3. Create a new credential
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        // 4. Sign in with Firebase
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        // 5. Save user info to Firestore in the "passengers" collection
        final userData = await FacebookAuth.instance.getUserData();

        await _firestore
            .collection('passengers')
            .doc(userCredential.user!.uid)
            .set({
          'DOB': FieldValue
              .serverTimestamp(), // Placeholder, get this from user input
          'DiaChi': '', // Placeholder, get this from user input
          'Email': userData['email'],
          'GioiTinh': 0, // Placeholder, consider using an enum or boolean
          'Name': userData['name'],
          'PassPort': '', // Placeholder, get this from user input
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
      LoginWithApplePressed event, Emitter<LoginState> emit) async {
    // Implement Apple Sign-In logic here
  }

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

  bool _validateEmail(String email) {
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.isNotEmpty;
  }
}
