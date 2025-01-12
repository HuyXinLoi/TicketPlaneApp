import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late StreamSubscription _subscription;
  bool isDeviceConnection = false;
  bool isAlertShown = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
    internetConnection();
    checkLogin();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      await Future.delayed(Duration(seconds: 3));
      if (mounted) context.go('/intro');
    } else {
      await Future.delayed(Duration(seconds: 3));
      if (mounted) context.go('/login');
    }
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      context.go('/nav');
    }
  }

  void internetConnection() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      isDeviceConnection = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnection && !isAlertShown) {
        showDialogBox();
      } else if (isDeviceConnection) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void showDialogBox() {
    setState(() {
      isLoading = false;
    });
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Mất Kết Nối - Quang Hùng MasterD'),
          content: Text('Kiểm Tra Mạng Của Bạn'),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  isAlertShown = false;
                  isLoading = true;
                });
                isDeviceConnection =
                    await InternetConnectionChecker().hasConnection;
                Navigator.pop(context);
                if (isDeviceConnection) {
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  showDialogBox();
                }
              },
              child: Text('OK'),
            )
          ],
        );
      },
    );
    setState(() {
      isAlertShown = true;
    });
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
            CircularProgressIndicator()
          ],
        )),
      ),
    );
  }
}
