import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/core.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'firebase_options.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  prefs = await SharedPreferences.getInstance();
  final authLocalDatasource = AuthLocalDatasourceImpl(prefs: prefs);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initialize();
  runApp(
    MyApp(authLocalDatasource: authLocalDatasource),
  );
}

class MyApp extends StatelessWidget {
  final AuthLocalDatasource authLocalDatasource;

  const MyApp({super.key, required this.authLocalDatasource});

  @override
  Widget build(BuildContext context) {
    return Providers(
      client: http.Client(),
      authLocalDatasource: authLocalDatasource,
      app: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attendance',
        theme: MyTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
