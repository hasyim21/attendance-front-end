import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../../main.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import 'add_permission_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFcmToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              context.push(const AddPermissionPage());
            },
            icon: const Icon(
              Icons.add,
              color: MyColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateFcmToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    final fcmToken = await firebaseMessaging.getToken();

    print('FCM Token: $fcmToken');

    if (await AuthLocalDatasourceImpl(prefs: prefs).getUser() != null) {
      AuthRemoteDatasourceImpl(
              client: http.Client(),
              authLocalDatasource: AuthLocalDatasourceImpl(prefs: prefs))
          .updateFcmToken(fcmToken!);
    }
  }
}
