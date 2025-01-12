import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_event.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_state.dart';
import 'package:ticket_plane_app/screen/profile/passenger.dart';
import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late PassengerRepository _passengerRepository;

  @override
  void initState() {
    super.initState();
    _passengerRepository = PassengerRepository();
    context.read<ProfileBloc>().add(LoadProfile(userId: widget.userId));
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userId != oldWidget.userId) {
      context.read<ProfileBloc>().add(LoadProfile(userId: widget.userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
          if (mounted) {
            context.go('/login');
          }
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
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(child: CircularProgressIndicator());
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            const Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),

                      // Profile Picture and Name
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(
                                  combinedUserData.containsKey('urlImage') &&
                                          combinedUserData['urlImage'] != null
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    Icons.card_membership,
                                    'Passport',
                                    combinedUserData.containsKey('passport')
                                        ? combinedUserData['passport']
                                        : 'N/A',
                                  ),
                                  _buildUserInfoItem(
                                    Icons.cake,
                                    'Ngày sinh',
                                    combinedUserData.containsKey('dateOfBirth')
                                        ? (combinedUserData['dateOfBirth']
                                                as Timestamp)
                                            .toDate()
                                            .toString()
                                            .substring(0, 10)
                                        : 'N/A',
                                  ),
                                  _buildUserInfoItem(
                                    Icons.person,
                                    'Giới tính',
                                    combinedUserData.containsKey('gender')
                                        ? combinedUserData['gender']
                                        : 'N/A',
                                  ),
                                  
                                  _buildUserInfoItem(
                                    Icons.email,
                                    'Email',
                                    combinedUserData.containsKey('email')
                                        ? combinedUserData['email']
                                        : 'N/A',
                                  ),
                                  _buildUserInfoItem(
                                    Icons.phone,
                                    'Số điện thoại',
                                    combinedUserData.containsKey('phoneNumber')
                                        ? combinedUserData['phoneNumber']
                                        : 'N/A',
                                  ),
                                  _buildUserInfoItem(
                                    Icons.location_on,
                                    'Địa chỉ',
                                    combinedUserData.containsKey('address')
                                        ? combinedUserData['address']
                                        : 'N/A',
                                  ),
                                  const SizedBox(height: 30),
                                  // Logout Button
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () => context
                                          .read<ProfileBloc>()
                                          .add(LogoutButtonPressed()),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 100),
                                        backgroundColor: Colors.redAccent,
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
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1976D2)),
          const SizedBox(width: 10),
          Column(
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
        ],
      ),
    );
  }
}