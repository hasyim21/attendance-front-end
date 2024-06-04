import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../bloc/get_attendance_history/get_attendance_history_bloc.dart';
import '../widgets/attendace_history_item.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  void initState() {
    //current date format yyyy-MM-dd used intl package
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //get attendance by date
    context
        .read<GetAttendanceHistoryBloc>()
        .add(GetAttendanceHistoryEvent(date: currentDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          EasyDateTimeLine(
            initialDate: DateTime.now(),

            // firstDate: DateTime(2019, 1, 15),
            // lastDate: DateTime.now().add(const Duration(days: 7)),
            onDateChange: (date) {
              final selectedDate = DateFormat('yyyy-MM-dd').format(date);

              context.read<GetAttendanceHistoryBloc>().add(
                    GetAttendanceHistoryEvent(date: selectedDate),
                  );
            },

            // leftMargin: 20,
            // monthColor: AppColors.grey,
            // dayColor: AppColors.black,
            // activeDayColor: Colors.white,
            // activeBackgroundDayColor: AppColors.primary,
            // showYears: true,
          ),
          const SpaceHeight(45.0),
          BlocBuilder<GetAttendanceHistoryBloc, GetAttendanceHistoryState>(
            builder: (context, state) {
              if (state is GetAttendanceHistoryLoading) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetAttendanceHistoryError) {
                return Center(
                  child: Text(state.failure.message),
                );
              }
              if (state is GetAttendanceHistorySuccess) {
                if (state.result.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada attendance'),
                  );
                }
                final attendance = state.result.first;
                final latlongInParts = attendance.latlonIn.split(',');
                final latitudeIn = double.parse(latlongInParts.first);
                final longitudeIn = double.parse(latlongInParts.last);

                final latlongOutParts = attendance.latlonOut.split(',');
                final latitudeOut = double.parse(latlongOutParts.first);
                final longitudeOut = double.parse(latlongOutParts.last);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AttendanceHistoryItem(
                      statusAbsen: 'Datang',
                      time: attendance.timeIn,
                      date: attendance.date.toString(),
                      latitude: latitudeIn,
                      longitude: longitudeIn,
                    ),
                    const SpaceHeight(16.0),
                    AttendanceHistoryItem(
                      statusAbsen: 'Pulang',
                      isCheckIn: false,
                      time: attendance.timeOut,
                      date: attendance.date.toString(),
                      latitude: latitudeOut,
                      longitude: longitudeOut,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
