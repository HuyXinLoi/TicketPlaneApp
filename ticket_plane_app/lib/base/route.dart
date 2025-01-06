import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/introduction/introduction_screen.dart';
import 'package:ticket_plane_app/screen/login/data/login_gg.dart';
import 'package:ticket_plane_app/screen/login/login_facebook.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';
import 'package:ticket_plane_app/screen/navigationbar/bottom_navigationbar_screen.dart';
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
        path: '/nav',
        builder: (context, state) => BottomNavBar(),
      ),
    ],
  );
}
