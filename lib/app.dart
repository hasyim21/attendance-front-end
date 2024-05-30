import 'package:flutter/material.dart';

import 'core/core.dart';
import 'features/auth/presentation/pages/splash_page.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance',
      theme: MyTheme.light,
      home: const SplashPage(),
    );
  }
}
