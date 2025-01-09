import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
    internetConnection();
    checkLogin();
  }

  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    if (savedUsername != null && savedPassword != null) {
      print('User is already logged in: \$savedUsername');
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
        await Future.delayed(Duration(seconds: 5));
        context.go('/intro');
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
          title: Text('Your connection is lost'),
          content: Text('Please check your connection'),
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
                  await Future.delayed(Duration(seconds: 5));
                  context.go('/intro');
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
