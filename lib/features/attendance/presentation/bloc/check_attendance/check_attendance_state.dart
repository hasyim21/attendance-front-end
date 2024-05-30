part of 'check_attendance_bloc.dart';

abstract class CheckAttendanceState extends Equatable {
  const CheckAttendanceState();

  @override
  List<Object> get props => [];
}

class CheckAttendanceInitial extends CheckAttendanceState {}

class CheckAttendanceLoading extends CheckAttendanceState {}

class CheckAttendanceSuccess extends CheckAttendanceState {
  final AttendanceStatus result;

  const CheckAttendanceSuccess({required this.result});
}

class CheckAttendanceError extends CheckAttendanceState {
  final Failure failure;

  const CheckAttendanceError({required this.failure});
}
