import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../../main.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../bloc/get_permissions/get_permissions_bloc.dart';
import '../widgets/permission_item.dart';
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
    context.read<GetPermissionsBloc>().add(const GetPermissionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin'),
        actions: [
          MyIconButton(
            onTap: () => context.push(const AddPermissionPage()),
            icon: Icons.add,
          ),
          const SpaceWidth(),
          // IconButton(
          //   onPressed: () {
          //     context.push(const AddPermissionPage());
          //   },
          //   icon: const Icon(
          //     Icons.add,
          //     color: MyColors.white,
          //   ),
          // ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<GetPermissionsBloc>().add(const GetPermissionsEvent()),
        child: BlocBuilder<GetPermissionsBloc, GetPermissionsState>(
          builder: (context, state) {
            if (state is GetPermissionsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetPermissionsSuccess) {
              if (state.result.isEmpty) {
                return const Center(
                  child: Text('Tidak ada izin'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final permission = state.result[index];
                  return PermissionItem(permission: permission);
                },
                separatorBuilder: (context, index) => const SpaceHeight(),
              );
            }
            return const Center(
              child: Text('Tidak ada izin'),
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateFcmToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    final fcmToken = await firebaseMessaging.getToken();

    if (await AuthLocalDatasourceImpl(prefs: prefs).getUser() != null) {
      AuthRemoteDatasourceImpl(
              client: http.Client(),
              authLocalDatasource: AuthLocalDatasourceImpl(prefs: prefs))
          .updateFcmToken(fcmToken!);
    }
  }
}
