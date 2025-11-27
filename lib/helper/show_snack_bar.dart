  import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, {required String message}) {
    // ScaffoldMessenger,SnackBar ==> it used to show a beautiful message for user from button
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }