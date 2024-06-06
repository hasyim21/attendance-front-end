import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../attendance/domain/entities/company.dart';
import '../../../attendance/presentation/bloc/check_attendance/check_attendance_bloc.dart';
import '../../../attendance/presentation/bloc/get_company/get_company_bloc.dart';
import '../../../attendance/presentation/pages/check_in_page.dart';
import '../../../attendance/presentation/pages/check_out_page.dart';
import '../../../note/presentation/bloc/get_notes/get_notes_bloc.dart';
import '../../../profile/presentation/bloc/bloc/get_user_profile_bloc.dart';
import '../widgets/attendance_button.dart';
import '../widgets/note_list.dart';
import '../widgets/user_profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AttendanceStatus? attendanceStatus;
  Company? company;

  @override
  void initState() {
    super.initState();
    context.read<GetUserProfileBloc>().add(const GetUserProfileEvent());
    context.read<CheckAttendanceBloc>().add(const CheckAttendanceEvent());
    context.read<GetCompanyBloc>().add(const GetCompanyEvent());
    context.read<GetNotesBloc>().add(const GetNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CheckAttendanceBloc>().add(const CheckAttendanceEvent());
          context.read<GetNotesBloc>().add(const GetNotesEvent());
        },
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              color: MyColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UserProfile(),
                  const SpaceHeight(16.0),
                  Text(
                    DateTime.now().toFormattedDate(),
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: MyColors.white,
                    ),
                  ),
                  const SpaceHeight(),
                  MultiBlocListener(
                    listeners: [
                      BlocListener<CheckAttendanceBloc, CheckAttendanceState>(
                        listener: (context, state) {
                          if (state is CheckAttendanceSuccess) {
                            setState(() {
                              attendanceStatus = state.result;
                            });
                          }
                        },
                      ),
                      BlocListener<GetCompanyBloc, GetCompanyState>(
                        listener: (context, state) {
                          if (state is GetCompanySuccess) {
                            setState(() {
                              company = state.result;
                            });
                          }
                        },
                      ),
                    ],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AttendanceButton(
                          label: 'Check In',
                          iconPath: Icons.arrow_circle_down,
                          time: '09:00 AM',
                          onPressed: () async {
                            await _detectFakeLocation();
                            await _checkUserDistanceFromCompany();
                            _checkInStatus();
                          },
                        ),
                        const SpaceWidth(),
                        AttendanceButton(
                          label: 'Check Out',
                          iconPath: Icons.arrow_circle_up,
                          time: '05:00 PM',
                          onPressed: () async {
                            await _detectFakeLocation();
                            await _checkUserDistanceFromCompany();
                            _checkOutStatus();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(16.0),
            const NoteList(),
            const SpaceHeight(16.0),
          ],
        ),
      ),
    );
  }

  Future<void> _detectFakeLocation() async {
    try {
      final isMocked = await LocationService.isLocationMocked();

      if (isMocked && mounted) {
        MySnackbar.show(
          context,
          message: 'Anda menggunakan lokasi palsu',
          backgroundColor: MyColors.red,
        );
        return;
      }
    } catch (e) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Gagal mendeteksi lokasi: $e',
          backgroundColor: MyColors.red,
        );
        return;
      }
    }
  }

  Future<void> _checkUserDistanceFromCompany() async {
    final userPosition = await LocationService.getCurrentPosition();
    final distanceToCompany = LocationService.calculateDistance(
      userPosition.latitude ?? 0.0,
      userPosition.longitude ?? 0.0,
      double.parse(company!.latitude),
      double.parse(company!.longitude),
    );
    final companyRadius = double.parse(company!.radiusKm);

    if (distanceToCompany > companyRadius) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Anda berada diluar jangkauan',
          backgroundColor: MyColors.red,
        );
      }
      return;
    }
  }

  void _checkInStatus() {
    if (attendanceStatus!.checkedin == true) {
      MySnackbar.show(
        context,
        message: 'Anda telah melakukan Check In',
        backgroundColor: MyColors.red,
      );
      return;
    }

    context.push(const CheckInPage());
  }

  void _checkOutStatus() {
    if (attendanceStatus!.checkedin == false) {
      MySnackbar.show(
        context,
        message: 'Anda belum melakukan Check In',
        backgroundColor: MyColors.red,
      );
      return;
    }

    if (attendanceStatus!.checkedout == true) {
      MySnackbar.show(
        context,
        message: 'Anda telah melakukan Check Out',
        backgroundColor: MyColors.red,
      );
      return;
    }

    context.push(const CheckOutPage());
  }
}
