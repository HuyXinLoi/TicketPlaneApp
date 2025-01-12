import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/infomationsingup/screen/infomation_signup_screen.dart';
import 'package:ticket_plane_app/screen/introduction/introduction_screen.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_bloc.dart';
import 'package:ticket_plane_app/screen/login/bloc/login_state.dart';
import 'package:ticket_plane_app/screen/login/data/login_gg.dart';
import 'package:ticket_plane_app/screen/login/login_facebook.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';
import 'package:ticket_plane_app/screen/navigationbar/bottom_navigationbar_screen.dart';
import 'package:ticket_plane_app/screen/profile/ChangePasswordScreen';
import 'package:ticket_plane_app/screen/profile/auth_repository.dart';
import 'package:ticket_plane_app/screen/profile/bloc/profile_bloc.dart';
import 'package:ticket_plane_app/screen/profile/passenger_repository.dart';
import 'package:ticket_plane_app/screen/profile/profile_screen.dart';
import 'package:ticket_plane_app/screen/sign_up/sign_up_screen.dart';
import 'package:ticket_plane_app/screen/splash/splash_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/intro',
        builder: (context, state) => OnBoardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/nav',
        builder: (context, state) => BottomNavBar(),
      ),
      GoRoute(
        path: '/loginfb',
        builder: (context, state) => FacebookAuthScreen(),
      ),
      GoRoute(
        path: '/logingg',
        builder: (context, state) => GoogleSignInScreen(),
      ),
      GoRoute(
        name: 'profile',
        path: '/profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        name: 'change_password',
        path: '/change_password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: '/user-info/:userId',
        builder: (context, state) =>
            UserInfoScreen(userId: state.pathParameters['userId']!),
      ),
    ],
  );
}
