import 'package:flutter/material.dart';

void showSnackBar(ScaffoldMessengerState scaffoldMessenger, String message) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
