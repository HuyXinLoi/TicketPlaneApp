import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/forgotpassword/forgot_passsword_screen.dart';
import 'package:ticket_plane_app/screen/infomationsingup/screen/infomation_signup_screen.dart';
import 'package:ticket_plane_app/screen/introduction/introduction_screen.dart';
import 'package:ticket_plane_app/screen/login/data/login_gg.dart';
import 'package:ticket_plane_app/screen/login/login_facebook.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';
import 'package:ticket_plane_app/screen/navigationbar/bottom_navigationbar_screen.dart';
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
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
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
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
    ],
  );
}
