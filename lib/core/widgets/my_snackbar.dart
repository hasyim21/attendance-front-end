import 'package:flutter/material.dart';

import '../core.dart';

class MySnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = MyColors.primary,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: MyColors.white),
      ),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
