import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/login/data/user.dart';
import 'package:ticket_plane_app/screen/profile/auth_repository.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';
import 'package:ticket_plane_app/screen/profile/passenger.dart';
import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final PassengerRepository _passengerRepository;

  ProfileBloc({
    required AuthRepository authRepository,
    required PassengerRepository passengerRepository,
  })  : _authRepository = authRepository,
        _passengerRepository = passengerRepository,
        super(ProfileInitial()) {
    on<LogoutButtonPressed>((event, emit) async {
      await _authRepository.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      emit(ProfileLoggedOut());
      emit(ProfileInitial());
    });

    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final results = await Future.wait([
          _passengerRepository.getUserById(event.userId),
          _passengerRepository.getUserData(event.userId),
        ]);

        final user = results[0] as Passenger?;
        final userData = results[1] as Map<String, dynamic>?;

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

    on<ChangePasswordPressed>((event, emit) async {
      emit(ProfileChangePasswordLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

        if (userId == null || userId.isEmpty) {
          emit(const ProfileChangePasswordFailure(
              message: 'User not logged in.'));
          return;
        }

        // Lấy email từ repository
        final userData = await _passengerRepository.getUserData(userId);
        final userEmail = userData?['email'];

        if (userEmail == null || userEmail.isEmpty) {
          emit(const ProfileChangePasswordFailure(message: 'Email not found.'));
          return;
        }

        // Kiểm tra mật khẩu mới
        if (event.newPassword.length < 6) {
          emit(const ProfileChangePasswordFailure(
              message: 'New password must be at least 6 characters.'));
          return;
        }

        if (event.newPassword != event.confirmNewPassword) {
          emit(const ProfileChangePasswordFailure(
              message: 'New passwords do not match.'));
          return;
        }

        // Xác thực lại mật khẩu cũ
        AuthCredential credential = EmailAuthProvider.credential(
            email: userEmail, password: event.oldPassword);
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);

        // Cập nhật mật khẩu mới
        await FirebaseAuth.instance.currentUser!
            .updatePassword(event.newPassword);

        // Gửi sự kiện ShowSnackBar để hiển thị thông báo
        add(const ShowSnackBar(
            message: 'Đổi mật khẩu thành công!', isError: false));

        emit(ProfileChangePasswordSuccess());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          add(const ShowSnackBar(
              message: 'Incorrect old password.', isError: true));
        } else if (e.code == 'weak-password') {
          add(const ShowSnackBar(
              message: 'New password is too weak.', isError: true));
        } else {
          add(ShowSnackBar(
              message: 'Failed to change password: ${e.message}',
              isError: true));
        }
      } catch (e) {
        add(ShowSnackBar(
            message: 'Unexpected error: ${e.toString()}', isError: true));
      } finally {
        emit(ProfileInitial());
      }
    });
    // on<LoadUserProfile>((event, emit) async {
    //   emit(ProfileLoading());
    //   try {
    //     final prefs = await SharedPreferences.getInstance();
    //     final userId = prefs.getString('userId');

    //     if (userId == null || userId.isEmpty) {
    //       emit(ProfileFailure(message: 'User not logged in.'));
    //       return;
    //     }

    //     final userData = await _passengerRepository.getUserData(userId) ??
    //         {}; // Use empty map if null
    //     emit(ProfileLoaded(userData: userData));
    //   } catch (e) {
    //     emit(ProfileFailure(message: 'Failed to load profile.'));
    //   }
    // });

    on<ShowSnackBar>((event, emit) {
      // Không thay đổi trạng thái, chỉ để xử lý logic hiển thị SnackBar
      emit(ProfileInitial());
    });

    on<ResetProfileState>((event, emit) {
      emit(ProfileInitial());
    });
  }
}
