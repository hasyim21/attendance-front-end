import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/logout/logout_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/bloc/get_user_profile_bloc.dart';
import '../widgets/profile_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: BlocBuilder<GetUserProfileBloc, GetUserProfileState>(
        builder: (context, state) {
          User? user;
          if (state is GetUserProfileSuccess) {
            user = state.result;
          }
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              const SpaceHeight(8.0),
              const Center(
                child: CircleAvatar(
                  radius: 60.0,
                ),
              ),
              const SpaceHeight(8.0),
              Center(
                child: Text(
                  user?.name ?? '-',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: MyColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  user?.position ?? '-',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: MyColors.grey,
                  ),
                ),
              ),
              const SpaceHeight(32.0),
              const Text(
                'Profil Saya',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(16.0),
              const MyDivider(),
              ProfileMenu(
                icon: Icons.work_outline,
                title: user?.position ?? '-',
              ),
              const MyDivider(),
              ProfileMenu(
                icon: Icons.email_outlined,
                title: user?.email ?? '-',
              ),
              const MyDivider(),
              ProfileMenu(
                icon: Icons.call_outlined,
                title: user?.phone ?? '-',
              ),
              const MyDivider(),
              const SpaceHeight(16.0),
              const Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SpaceHeight(16.0),
              const MyDivider(),
              BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  if (state is LogoutLoading) {
                    showDialogLoading(context);
                  }
                  if (state is LogoutSuccess) {
                    context.pushAndRemoveUntil(
                        const LoginPage(), (route) => true);
                  }
                },
                child: ProfileMenu(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  onTap: () =>
                      context.read<LogoutBloc>().add(const LogoutEvent()),
                ),
              ),
              const MyDivider(),
            ],
          );
        },
      ),
    );
  }
}
