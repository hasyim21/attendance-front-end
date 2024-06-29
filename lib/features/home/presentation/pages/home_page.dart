import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../attendance/domain/entities/attendance_status.dart';
import '../../../attendance/domain/entities/company.dart';
import '../../../attendance/presentation/bloc/check_attendance/check_attendance_bloc.dart';
import '../../../attendance/presentation/bloc/get_company/get_company_bloc.dart';
import '../../../attendance/presentation/pages/check_in_page.dart';
import '../../../attendance/presentation/pages/check_out_page.dart';
import '../../../attendance/presentation/pages/register_face_page.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../note/presentation/bloc/notes/notes_bloc.dart';
import '../../../note/presentation/pages/add_note_page.dart';
import '../../../profile/presentation/bloc/get_user_profile/get_user_profile_bloc.dart';
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
    context.read<NotesBloc>().add(GetNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.0),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CheckAttendanceBloc>().add(const CheckAttendanceEvent());
          context.read<NotesBloc>().add(RefreshNotesEvent());
        },
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
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 75.0,
                left: 12.0,
                right: 12.0,
              ),
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
                                  print(attendanceStatus);
                                }
                              },
                            ),
                            BlocListener<GetCompanyBloc, GetCompanyState>(
                              listener: (context, state) {
                                if (state is GetCompanySuccess) {
                                  setState(() {
                                    company = state.result;
                                  });
                                  print(company);
                                }
                              },
                            ),
                          ],
                          child: BlocBuilder<GetUserProfileBloc,
                              GetUserProfileState>(
                            builder: (context, state) {
                              if (state is GetUserProfileSuccess) {
                                final user = state.result;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AttendanceButton(
                                      label: 'Check In',
                                      iconPath: Icons.arrow_circle_down,
                                      buttonColor: Colors.green.shade500,
                                      borderButtonColor: Colors.green.shade400,
                                      time: user.timeIn.toFormattedTime(),
                                      onPressed: () async {
                                        await _checkIn(user);
                                      },
                                    ),
                                    const SpaceWidth(12.0),
                                    AttendanceButton(
                                      label: 'Check Out',
                                      iconPath: Icons.arrow_circle_up,
                                      buttonColor: Colors.red.shade500,
                                      borderButtonColor: Colors.red.shade300,
                                      time: user.timeOut.toFormattedTime(),
                                      onPressed: () async {
                                        await _checkOut(user);
                                      },
                                    ),
                                  ],
                                );
                              }
                              return const _InitialAttendanceButton();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Catatan",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MyIconButton(
                        onTap: () => context.push(const AddNotePage()),
                        icon: Icons.add,
                      ),
                    ],
                  ),
                  const SpaceHeight(16.0),
                  const NoteList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkIn(User user) async {
    if (attendanceStatus!.checkedin == true) {
      MySnackbar.show(
        context,
        message: 'Anda telah melakukan Check In',
        backgroundColor: MyColors.red,
      );
      return;
    }

    if (!_isLateToCheckIn(user.timeIn)) {
      MySnackbar.show(
        context,
        message:
            'Gagal Check In!. Telat lebih dari ${company!.lateTolerance} menit',
        backgroundColor: MyColors.red,
      );
      return;
    }

    if (await _isLocationMocked()) return;
    if (!await _isWithinCompanyRadius()) return;

    if (mounted) {
      if (user.faceEmbedding == null) {
        _showRegisterFaceDialog();
      } else {
        context.push(const CheckInPage());
      }
    }
  }

  Future<void> _checkOut(User user) async {
    // if (attendanceStatus!.checkedin == false) {
    //   MySnackbar.show(
    //     context,
    //     message: 'Anda belum melakukan Check In',
    //     backgroundColor: MyColors.red,
    //   );
    //   return;
    // }

    if (attendanceStatus!.checkedout == true) {
      MySnackbar.show(
        context,
        message: 'Anda telah melakukan Check Out',
        backgroundColor: MyColors.red,
      );
      return;
    }

    if (!_isTimeToCheckOut(user.timeOut)) {
      MySnackbar.show(
        context,
        message:
            'Gagal Check Out! Waktu Check Out anda adalah ${user.timeOut.toFormattedTime()}',
        backgroundColor: MyColors.red,
      );
      return;
    }

    if (await _isLocationMocked()) return;
    if (!await _isWithinCompanyRadius()) return;

    if (mounted) {
      context.push(const CheckOutPage());
    }
  }

  bool _isLateToCheckIn(String time) {
    DateTime targetTime = DateFormat('HH:mm:ss').parse(time);
    DateTime now = DateTime.now();
    return now.difference(targetTime).inMinutes <= company!.lateTolerance;
  }

  bool _isTimeToCheckOut(String time) {
    DateTime targetTime = DateFormat('HH:mm:ss').parse(time);
    DateTime now = DateTime.now();
    return now.isAtSameMomentAs(targetTime) || now.isAfter(targetTime);
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

  void _showRegisterFaceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Daftar Wajah Diperlukan'),
          content: const Text(
              'Anda belum mendaftarkan wajah Anda. Harap daftar untuk melanjutkan.'),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: const Text('Daftar Sekarang'),
              onPressed: () {
                context.pop();
                context.push(const RegisterFacePage());
              },
            ),
          ],
        );
      },
    );
  }
}

class _InitialAttendanceButton extends StatelessWidget {
  const _InitialAttendanceButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AttendanceButton(
          label: 'Check In',
          iconPath: Icons.arrow_circle_down,
          buttonColor: Colors.green.shade500,
          borderButtonColor: Colors.green.shade400,
          time: '--:--',
          onPressed: () {},
        ),
        const SpaceWidth(12.0),
        AttendanceButton(
          label: 'Check Out',
          iconPath: Icons.arrow_circle_up,
          buttonColor: Colors.red.shade500,
          borderButtonColor: Colors.red.shade300,
          time: '--:--',
          onPressed: () {},
        ),
      ],
    );
  }
}
