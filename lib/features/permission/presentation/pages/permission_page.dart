import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../../main.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../data/models/permission_status.dart';
import '../bloc/get_permissions/get_permissions_bloc.dart';
import '../widgets/permission_category_item.dart';
import '../widgets/permission_item.dart';
import 'add_permission_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFcmToken();
    });
    _initialPermission();
  }

  void _onTap(int index, int isApproved) {
    setState(() {
      _selectedIndex = index;
    });
    context
        .read<GetPermissionsBloc>()
        .add(GetPermissionsEvent(isApproved: isApproved));
  }

  void _initialPermission() {
    _onTap(0, PermissionStatus.all.value);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izin'),
        actions: [
          IconButton(
            onPressed: () => context.push(const AddPermissionPage()),
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _initialPermission(),
        child: ListView(
          children: [
            const SpaceHeight(12.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 35.0,
                child: BlocBuilder<GetPermissionsBloc, GetPermissionsState>(
                  builder: (context, state) {
                    if (state is GetPermissionsLoading) {
                      return const ShimmerHorizontalLoading();
                    }
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        PermissionCategoryItem(
                          label: 'Semua',
                          isSelected: _selectedIndex == 0,
                          onTap: () => _onTap(0, PermissionStatus.all.value),
                        ),
                        PermissionCategoryItem(
                          label: 'Diproses',
                          isSelected: _selectedIndex == 1,
                          onTap: () =>
                              _onTap(1, PermissionStatus.process.value),
                        ),
                        PermissionCategoryItem(
                          label: 'Disetujui',
                          isSelected: _selectedIndex == 2,
                          onTap: () =>
                              _onTap(2, PermissionStatus.approved.value),
                        ),
                        PermissionCategoryItem(
                          label: 'Ditolak',
                          isSelected: _selectedIndex == 3,
                          onTap: () => _onTap(3, PermissionStatus.reject.value),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SpaceHeight(4.0),
            BlocBuilder<GetPermissionsBloc, GetPermissionsState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case GetPermissionsError:
                    final errorState = state as GetPermissionsError;
                    return Center(
                      child: Text(errorState.failure.message),
                    );
                  case GetPermissionsLoading:
                    return const ShimmerVerticalLoading(
                      height: 109.0,
                      isScrolled: false,
                    );
                  case GetPermissionsSuccess:
                    final successState = state as GetPermissionsSuccess;
                    if (successState.result.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada izin'),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: successState.result.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final permission = successState.result[index];
                        return PermissionItem(permission: permission);
                      },
                      separatorBuilder: (context, index) => const SpaceHeight(),
                    );
                  default:
                    return const Center(
                      child: Text('Tidak ada izin'),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
