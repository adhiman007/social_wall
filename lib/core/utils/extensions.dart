import 'dart:io';

import 'package:flutter/material.dart';

extension EmailValidatorExtension on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension InternetConnectivityExtension on BuildContext {
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        showSnackbar('No Internet Connection');
        return false;
      }
    } on SocketException catch (_) {
      showSnackbar('No Internet Connection');
      return false;
    }
  }
}

extension SnackbarExtension on BuildContext {
  void showSnackbar(String message) =>
      ScaffoldMessenger.of(this).showSnackBar(SnackBar(
        content: Text(message),
      ));
}
