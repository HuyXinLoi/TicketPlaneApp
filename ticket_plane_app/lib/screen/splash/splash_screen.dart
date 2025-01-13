import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription _subscription;
  bool isDeviceConnected = false;
  bool isAlertShown = false;
  bool shouldNavigate = false;

  @override
  void initState() {
    super.initState();
    getConnectivity();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final userId = prefs.getString('userId');

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && isDeviceConnected) {
        if (isFirstTime) {
          prefs.setBool('isFirstTime', false);
          context.go('/intro');
        } else if (userId!.isEmpty) {
          context.go('/login');
        } else {
          context.go('/nav');
        }
      } else {
        shouldNavigate = true;
      }
    });
  }

  void getConnectivity() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected && !isAlertShown) {
        showDialogBox();
        setState(() => isAlertShown = true);
      } else if (isDeviceConnected && shouldNavigate) {
        _checkFirstTime();
      }
    });
  }

  void showDialogBox() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Mất Kết Nối - Dương DOMINIC'),
          content: const Text('Kiểm Tra Mạng Của Bạn'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => isAlertShown = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  setState(() => isAlertShown = true);
                }
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 148, 183, 236),
              Color.fromARGB(255, 237, 240, 241),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImage('images/logo.png'),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
