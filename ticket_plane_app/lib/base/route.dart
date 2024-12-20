import 'package:go_router/go_router.dart';
import 'package:ticket_plane_app/screen/introduction/introduction_screen.dart';
import 'package:ticket_plane_app/screen/login/login_screen.dart';

class AppRouter {
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => OnBoardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
    ],
  );
}
