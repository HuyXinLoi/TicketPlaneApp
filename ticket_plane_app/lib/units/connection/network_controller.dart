import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? subscription;
  SnackbarController? _snackbarController;

  @override
  void onInit() {
    super.onInit();
    subscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      _snackbarController = Get.rawSnackbar(
        messageText: const Text(
          'No internet connection. Please check your network.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        isDismissible: false,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      _snackbarController?.close();
      _snackbarController = null;
    }
  }

  @override
  void onClose() {
    subscription?.cancel();
    super.onClose();
  }
}
