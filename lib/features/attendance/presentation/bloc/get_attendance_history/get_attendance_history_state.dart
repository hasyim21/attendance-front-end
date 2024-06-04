part of 'get_attendance_history_bloc.dart';

abstract class GetAttendanceHistoryState extends Equatable {
  const GetAttendanceHistoryState();

  @override
  List<Object> get props => [];
}

class GetAttendanceHistoryInitial extends GetAttendanceHistoryState {}

class GetAttendanceHistoryLoading extends GetAttendanceHistoryState {}

class GetAttendanceHistorySuccess extends GetAttendanceHistoryState {
  final List<Attendance> result;

  const GetAttendanceHistorySuccess({required this.result});
}

class GetAttendanceHistoryError extends GetAttendanceHistoryState {
  final Failure failure;

  const GetAttendanceHistoryError({required this.failure});
}
