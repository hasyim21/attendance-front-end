import 'package:flutter/material.dart';

import '../core.dart';

class MyTheme {
  static ThemeData light = ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      brightness: Brightness.light,
      primary: MyColors.primary,
    ),
    scaffoldBackgroundColor: MyColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: MyColors.primary,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: MyColors.white),
      titleSpacing: 12.0,
      titleTextStyle: TextStyle(
        fontSize: 18.0,
        color: MyColors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: MyColors.white,
      selectedLabelStyle: TextStyle(
        color: MyColors.primary,
        fontSize: 12.0,
      ),
      unselectedLabelStyle: TextStyle(
        color: MyColors.grey,
        fontSize: 12.0,
      ),
      selectedIconTheme: IconThemeData(
        color: MyColors.primary,
      ),
      unselectedIconTheme: IconThemeData(
        color: MyColors.grey,
      ),
    ),
  );
}
