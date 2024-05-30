part of 'check_in_bloc.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object> get props => [];
}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final Attendance result;

  const CheckInSuccess({required this.result});
}

class CheckInError extends CheckInState {
  final Failure failure;

  const CheckInError({required this.failure});
}
