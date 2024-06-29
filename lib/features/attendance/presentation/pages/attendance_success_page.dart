import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../bloc/check_attendance/check_attendance_bloc.dart';
import '../bloc/get_attendance_history/get_attendance_history_bloc.dart';

class AttendanceSuccessPage extends StatefulWidget {
  final String status;

  const AttendanceSuccessPage({
    super.key,
    required this.status,
  });

  @override
  State<AttendanceSuccessPage> createState() => _AttendanceSuccessPageState();
}

class _AttendanceSuccessPageState extends State<AttendanceSuccessPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDates();
  }

  void _initializeDates() {
    final now = DateTime.now();
    _startDateController.text =
        DateTime(now.year, now.month, 1).toIsoFormattedDate();
    _endDateController.text =
        DateTime(now.year, now.month + 1, 0).toIsoFormattedDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: MyColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.success.image(height: 300.0),
            const Text(
              'Sukses !',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SpaceHeight(16.0),
            Center(
              child: Text(
                'Anda telah melakukan ${widget.status} Pukul ${DateTime.now().toFormattedTime()}.',
                textAlign: TextAlign.center,
              ),
            ),
            const Center(
              child: Text(
                'Selamat bekerja.',
                textAlign: TextAlign.center,
              ),
            ),
            const SpaceHeight(80.0),
            MyButton.filled(
              onPressed: () {
                context
                    .read<CheckAttendanceBloc>()
                    .add(const CheckAttendanceEvent());
                context.read<GetAttendanceHistoryBloc>().add(
                      GetAttendanceHistoryEvent(
                        startDate: _startDateController.text,
                        endDate: _endDateController.text,
                      ),
                    );
                context.popToRoot();
              },
              label: 'Kembali',
            ),
          ],
        ),
      ),
    );
  }
}
