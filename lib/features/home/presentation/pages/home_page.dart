import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../attendance/presentation/pages/check_in_page.dart';
import '../../../attendance/presentation/pages/check_out_page.dart';
import '../../../auth/presentation/bloc/logout/logout_bloc.dart';
import '../widgets/attendance_button.dart';
import '../widgets/note_item.dart';
import '../widgets/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _detectFakeLocation() async {
    try {
      final isMocked = await LocationService.isLocationMocked();

      if (isMocked && mounted) {
        MySnackbar.show(
          context,
          message: 'Anda menggunakan lokasi palsu',
          backgroundColor: MyColors.red,
        );
      }

      return isMocked;
    } catch (e) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Gagal mendeteksi lokasi: $e',
          backgroundColor: MyColors.red,
        );
      }

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: MyColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: UserProfile(),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),
                const SpaceHeight(),
                Text(
                  DateTime.now().toFormattedDate(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: MyColors.white,
                  ),
                ),
                const SpaceHeight(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AttendanceButton(
                      label: 'Check In',
                      iconPath: Icons.arrow_circle_down,
                      time: '09:00 AM',
                      onPressed: () async {
                        await LocationService.checkAndEnableGeolocatorService();

                        bool isFakeLocation = await _detectFakeLocation();

                        if (!isFakeLocation && context.mounted) {
                          context.push(const CheckInPage());
                        }
                      },
                    ),
                    const SpaceWidth(8.0),
                    AttendanceButton(
                      label: 'Check Out',
                      iconPath: Icons.arrow_circle_up,
                      time: '05:00 PM',
                      onPressed: () async {
                        await LocationService.checkAndEnableGeolocatorService();

                        bool isFakeLocation = await _detectFakeLocation();

                        if (!isFakeLocation && context.mounted) {
                          context.push(const CheckOutPage());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SpaceHeight(16.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Catatan",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.add,
                ),
              ],
            ),
          ),
          const SpaceHeight(16.0),
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const NoteItem(
                title: 'Meeting penting',
                note: 'Jam 10:00 AM',
              );
            },
            separatorBuilder: (context, index) => const SpaceHeight(),
          ),
          const SpaceHeight(16.0),
          Button.filled(
            onPressed: () {
              context.read<LogoutBloc>().add(const LogoutEvent());
            },
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
