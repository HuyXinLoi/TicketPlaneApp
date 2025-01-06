// Project: ticket_plane_app
import 'package:flutter/material.dart';
import 'package:ticket_plane_app/base/route.dart';

void main() {
  runApp(const MainApp());
  //DependencyInjection.init();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();

    return MaterialApp.router(
      routerConfig: appRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
