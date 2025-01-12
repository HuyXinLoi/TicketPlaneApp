import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';

import 'package:ticket_plane_app/screen/profile/passenger.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';
import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _isBiometricsEnabledKey = 'isBiometricsEnabled';
  final LocalAuthentication auth = LocalAuthentication();
  late PassengerRepository _passengerRepository;
  String? _userId;

  Future<bool> _authenticateWithBiometrics() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Vui lòng xác thực bằng vân tay để tiếp tục.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return authenticated;
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled') {
        _showFlushbar(
            'Thiết bị không hỗ trợ hoặc chưa thiết lập sinh trắc học.',
            Colors.orangeAccent);
      } else {
        _showFlushbar(
            'Xác Thực Sinh Trắc Học Lỗi hoặc bị hủy.', Colors.redAccent);
      }
      return false;
    }
  }

  Future<void> _toggleBiometrics(bool value) async {
    if (value) {
      final authenticated = await _authenticateWithBiometrics();
      if (!authenticated) {
        return;
      }
    }
    await _setBiometricsEnabled(value);
    setState(() {});
  }

  Future<void> _setBiometricsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isBiometricsEnabledKey, value);
  }

  Future<bool> _getBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isBiometricsEnabledKey) ?? false;
  }

  void _showBiometricsScreen(BuildContext context) async {
    bool isBiometricsEnabled = await _getBiometricsEnabled();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sinh trắc học',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bật/Tắt Sinh trắc học'),
                      Switch(
                        value: isBiometricsEnabled,
                        onChanged: (value) async {
                          await _toggleBiometrics(value);
                          setModalState(() {
                            isBiometricsEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFlushbar(String message, Color color) {
    Flushbar(
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.error,
        size: 28,
        color: Colors.white,
      ),
    ).show(context);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    context.go('/login');
  }

  @override
  void initState() {
    super.initState();
    _passengerRepository = PassengerRepository();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });
    if (_userId != null) {
      context.read<ProfileBloc>().add(LoadProfile(userId: _userId!));
    }
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   context.read<ProfileBloc>().add(LoadUserProfile());
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            if (mounted) {
              context.go('/login');
            }
          } else if (state is ProfileChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đổi mật khẩu thành công!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileChangePasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                ],
              ),
            ),
            child: SafeArea(
              child: _userId == null
                  ? const Center(child: CircularProgressIndicator())
                  : BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is ProfileError) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else if (state is ProfileLoaded) {
                          final combinedUserData = state.userData;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Spacer(), // Căn giữa tiêu đề
                                    const Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(), // Căn giữa tiêu đề
                                  ],
                                ),
                              ),

                              // Profile Picture and Name
                              Center(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(combinedUserData
                                                  .containsKey('urlImage') &&
                                              combinedUserData['urlImage'] !=
                                                  null
                                          ? combinedUserData['urlImage']
                                          : 'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1287&q=80'),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      combinedUserData.containsKey('name')
                                          ? combinedUserData['name'] as String
                                          : 'N/A',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Body Content
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),

                                          // Personal Information
                                          const Text(
                                            'Thông tin cá nhân',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          _buildUserInfoItem(
                                            Icons.email,
                                            'Email',
                                            combinedUserData
                                                    .containsKey('email')
                                                ? combinedUserData['email']
                                                : 'N/A',
                                          ),
                                          _buildUserInfoItem(
                                            Icons.phone,
                                            'Số điện thoại',
                                            combinedUserData
                                                    .containsKey('phoneNumber')
                                                ? combinedUserData[
                                                    'phoneNumber']
                                                : 'N/A',
                                          ),
                                          _buildUserInfoItem(
                                            Icons.location_on,
                                            'Địa chỉ',
                                            combinedUserData
                                                    .containsKey('address')
                                                ? combinedUserData['address']
                                                : 'N/A',
                                          ),
                                          _buildUserInfoItem(
                                            Icons.card_membership,
                                            'Passport',
                                            combinedUserData
                                                    .containsKey('passport')
                                                ? combinedUserData['passport']
                                                : 'N/A',
                                          ),
                                          _buildUserInfoItem(
                                            Icons.cake,
                                            'Ngày sinh',
                                            combinedUserData
                                                    .containsKey('dateOfBirth')
                                                ? (combinedUserData[
                                                            'dateOfBirth']
                                                        as Timestamp)
                                                    .toDate()
                                                    .toString()
                                                    .substring(0, 10)
                                                : 'N/A',
                                          ),
                                          _buildUserInfoItem(
                                            Icons.person,
                                            'Giới tính',
                                            combinedUserData
                                                    .containsKey('gender')
                                                ? combinedUserData['gender']
                                                : 'N/A',
                                          ),

                                          const SizedBox(height: 30),

                                          // Change Password Button
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                context.read<ProfileBloc>().add(
                                                    ResetProfileState()); // Reset state
                                                context.pushNamed(
                                                    'change_password');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 100),
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                'Đổi mật khẩu',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 30),

                                          // Logout Button
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () => context
                                                  .read<ProfileBloc>()
                                                  .add(LogoutButtonPressed()),
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 100),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                'Đăng xuất',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (state is ProfileInitial) {
                          return const Center(
                              child: Text(
                                  "User not logged in.")); //cái này để tạm thời, bạn có thể bỏ
                        } else {
                          return Container();
                        }
                      },
                    ),
            ),
          ),
        ));
  }

  Widget _buildUserInfoItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1976D2)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
