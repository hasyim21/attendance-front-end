import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../../main.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/datasources/auth_remote_datasource.dart';
import '../../data/models/permission_status.dart';
import '../bloc/permissions/permissions_bloc.dart';
import '../widgets/permission_category_item.dart';
import '../widgets/permission_item.dart';
import 'add_permission_page.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  final _scrollController = ScrollController();
  int _selectedIndex = 0;
  int _isApproved = PermissionStatus.all.value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFcmToken();
    });
    _initialPermission();
    _scrollController.addListener(_scrollEvent);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollEvent)
      ..dispose();
    super.dispose();
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
        onRefresh: () async => _onRefresh(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 35.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    PermissionCategoryItem(
                      label: 'Semua',
                      isSelected: _selectedIndex == 0,
                      onTap: () {
                        _onTap(0, PermissionStatus.all.value);
                      },
                    ),
                    PermissionCategoryItem(
                      label: 'Diproses',
                      isSelected: _selectedIndex == 1,
                      onTap: () {
                        _onTap(1, PermissionStatus.process.value);
                      },
                    ),
                    PermissionCategoryItem(
                      label: 'Disetujui',
                      isSelected: _selectedIndex == 2,
                      onTap: () {
                        _onTap(2, PermissionStatus.approved.value);
                      },
                    ),
                    PermissionCategoryItem(
                      label: 'Ditolak',
                      isSelected: _selectedIndex == 3,
                      onTap: () {
                        _onTap(3, PermissionStatus.reject.value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<PermissionsBloc, PermissionsState>(
              builder: (context, state) {
                switch (state.status) {
                  case PermissionsStatus.failure:
                    return Center(
                      child: Text(state.message),
                    );
                  case PermissionsStatus.success:
                    if (state.permissions.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada izin'),
                      );
                    }
                    return Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 12.0,
                        ),
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.hasReachedMax
                            ? state.permissions.length
                            : state.permissions.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.permissions.length) {
                            final permission = state.permissions[index];
                            return PermissionItem(permission: permission);
                          } else {
                            return const BottomLoading();
                          }
                        },
                        separatorBuilder: (context, index) =>
                            const SpaceHeight(),
                      ),
                    );
                  case PermissionsStatus.initial:
                    return const Expanded(
                      child: ShimmerVerticalLoading(
                        height: 109.0,
                        isScrolled: true,
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _initialPermission() {
    _onTap(0, PermissionStatus.all.value);
  }

  void _onTap(int index, int isApproved) {
    setState(() {
      _selectedIndex = index;
      _isApproved = isApproved;
    });
    context.read<PermissionsBloc>().add(
          RefreshPermissionsEvent(isApproved: _isApproved),
        );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _selectedIndex = 0;
      _isApproved = PermissionStatus.all.value;
    });
    context
        .read<PermissionsBloc>()
        .add(RefreshPermissionsEvent(isApproved: _isApproved));
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

  void _scrollEvent() {
    if (_isBottom) {
      context.read<PermissionsBloc>().add(
            GetPermissionsEvent(isApproved: _isApproved),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll == maxScroll;
  }
}
