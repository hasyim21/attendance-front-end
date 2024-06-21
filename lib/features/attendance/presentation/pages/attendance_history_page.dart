import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../bloc/get_attendance_history/get_attendance_history_bloc.dart';
import '../widgets/attendace_history_item.dart';
import '../widgets/date_range_picker.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _getAttendanceHistory();
  }

  void _initializeDates() {
    final now = DateTime.now();
    _startDateController.text =
        DateTime(now.year, now.month, 1).toIsoFormattedDate();
    _endDateController.text =
        DateTime(now.year, now.month + 1, 0).toIsoFormattedDate();
  }

  void _getAttendanceHistory() {
    _validateAndGetData(_startDateController.text, _endDateController.text);
  }

  void _validateAndGetData(String startDate, String endDate) {
    bool isInvalidRange =
        DateTime.parse(startDate).isAfter(DateTime.parse(endDate));

    if (isInvalidRange) {
      MySnackbar.show(
        context,
        message: 'Tanggal mulai melebihi tanggal akhir.',
        backgroundColor: MyColors.red,
      );
      return;
    } else {
      context.read<GetAttendanceHistoryBloc>().add(
            GetAttendanceHistoryEvent(
              startDate: startDate,
              endDate: endDate,
            ),
          );
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _getAttendanceHistory(),
        child: Column(
          children: [
            DateRangePicker(
              startDateController: _startDateController,
              endDateController: _endDateController,
              onSearch: _getAttendanceHistory,
            ),
            const SpaceHeight(12.0),
            BlocBuilder<GetAttendanceHistoryBloc, GetAttendanceHistoryState>(
              builder: (context, state) {
                switch (state.runtimeType) {
                  case GetAttendanceHistoryError:
                    final errorState = state as GetAttendanceHistoryError;
                    return Center(
                      child: Text(errorState.failure.message),
                    );
                  case GetAttendanceHistoryLoading:
                    return const Expanded(
                      child: ShimmerVerticalLoading(
                        height: 91.0,
                        isScrolled: true,
                      ),
                    );
                  case GetAttendanceHistorySuccess:
                    final successState = state as GetAttendanceHistorySuccess;
                    if (successState.result.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada attendance'),
                      );
                    }
                    return Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: successState.result.length,
                        separatorBuilder: (context, index) =>
                            const SpaceHeight(),
                        itemBuilder: (context, index) {
                          final data = successState.result[index];
                          return AttendanceHistoryItem(data: data);
                        },
                      ),
                    );
                  default:
                    return const Center(
                      child: Text('Tidak ada attendance'),
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
