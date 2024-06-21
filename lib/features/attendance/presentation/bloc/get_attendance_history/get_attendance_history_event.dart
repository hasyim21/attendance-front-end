part of 'get_attendance_history_bloc.dart';

class GetAttendanceHistoryEvent extends Equatable {
  final String startDate;
  final String endDate;

  const GetAttendanceHistoryEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [];
}
