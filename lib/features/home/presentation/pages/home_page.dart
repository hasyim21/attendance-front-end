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
import '../widgets/date_and_clock.dart';
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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    color: MyColors.primary,
                    child: const Column(
                      children: [
                        UserProfile(),
                        SpaceHeight(77.5),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
              Positioned(
                top: 75.0,
                left: 12.0,
                right: 12.0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const DateAndClock(),
                          const SpaceHeight(12.0),
                          const MyDivider(thickness: 1.0),
                          const SpaceHeight(12.0),
                          MultiBlocListener(
                            listeners: [
                              BlocListener<CheckAttendanceBloc,
                                  CheckAttendanceState>(
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
                                  buttonColor: Colors.green.shade500,
                                  borderButtonColor: Colors.green.shade400,
                                  time: '09:00 AM',
                                  onPressed: () async {
                                    await _checkIn();
                                  },
                                ),
                                const SpaceWidth(12.0),
                                AttendanceButton(
                                  label: 'Check Out',
                                  iconPath: Icons.arrow_circle_up,
                                  buttonColor: Colors.red.shade500,
                                  borderButtonColor: Colors.red.shade300,
                                  time: '05:00 PM',
                                  onPressed: () async {
                                    await _checkOut();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceHeight(24.0),
                    const NoteList(),
                    const SpaceHeight(16.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _isLocationMocked() async {
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

  Future<bool> _isWithinCompanyRadius() async {
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
      return false;
    }
    return true;
  }

  Future<void> _checkIn() async {
    if (await _isLocationMocked()) return;
    if (!await _isWithinCompanyRadius()) return;

    if (attendanceStatus!.checkedin == true) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Anda telah melakukan Check In',
          backgroundColor: MyColors.red,
        );
      }
      return;
    }
    if (mounted) {
      context.push(const CheckInPage());
    }
  }

  Future<void> _checkOut() async {
    if (await _isLocationMocked()) return;
    if (!await _isWithinCompanyRadius()) return;

    if (attendanceStatus!.checkedin == false) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Anda belum melakukan Check In',
          backgroundColor: MyColors.red,
        );
      }
      return;
    }

    if (attendanceStatus!.checkedout == true) {
      if (mounted) {
        MySnackbar.show(
          context,
          message: 'Anda telah melakukan Check Out',
          backgroundColor: MyColors.red,
        );
      }
      return;
    }
    if (mounted) {
      context.push(const CheckOutPage());
    }
  }
}
