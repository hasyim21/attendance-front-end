import 'package:flutter/material.dart';

import '../core.dart';

class MyTheme {
  static ThemeData light = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: MyColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: MyColors.primary,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: MyColors.white),
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        color: MyColors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: MyColors.white,
      selectedLabelStyle: TextStyle(color: MyColors.primary),
      unselectedLabelStyle: TextStyle(color: MyColors.grey),
      selectedIconTheme: IconThemeData(color: MyColors.primary),
      unselectedIconTheme: IconThemeData(
        color: MyColors.grey,
      ),
    ),
  );
}
