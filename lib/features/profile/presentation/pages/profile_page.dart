import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/logout/logout_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/bloc/get_user_profile_bloc.dart';
import '../widgets/contact_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    context.read<GetUserProfileBloc>().add(const GetUserProfileEvent());
  }

  double coverHeight = 100.0;
  double profilHeight = 120.0;
  double get top => coverHeight - profilHeight / 2;
  double get bottom => profilHeight / 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutLoading) {
                showDialogLoading(context);
              }
              if (state is LogoutSuccess) {
                context.pushAndRemoveUntil(const LoginPage(), (route) => true);
              }
            },
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: GestureDetector(
                      onTap: () =>
                          context.read<LogoutBloc>().add(const LogoutEvent()),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout_outlined,
                          ),
                          SpaceWidth(),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
            ),
          )
        ],
      ),
      body: BlocBuilder<GetUserProfileBloc, GetUserProfileState>(
        builder: (context, state) {
          if (state is GetUserProfileSuccess) {
            user = state.result;
          }
          return ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    color: MyColors.primary,
                    height: coverHeight,
                    margin: EdgeInsets.only(bottom: bottom),
                  ),
                  Positioned(
                    top: top,
                    child: CircleAvatar(
                      radius: profilHeight / 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Text(
                      user?.name ?? '-',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(user?.position ?? '-'),
                    Text(user?.department ?? '-'),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ContactInfo(
                      title: "Phone Number",
                      value: user?.phone ?? '-',
                      icon: Icons.call,
                    ),
                    ContactInfo(
                      title: "Email",
                      value: user?.email ?? '-',
                      icon: Icons.email,
                    ),
                    const ContactInfo(
                      title: "Address",
                      value: 'address',
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
