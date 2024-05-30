part of 'check_out_bloc.dart';

abstract class CheckOutState extends Equatable {
  const CheckOutState();

  @override
  List<Object> get props => [];
}

class CheckOutInitial extends CheckOutState {}

class CheckOutLoading extends CheckOutState {}

class CheckOutSuccess extends CheckOutState {
  final Attendance result;

  const CheckOutSuccess({required this.result});
}

class CheckOutError extends CheckOutState {
  final Failure failure;

  const CheckOutError({required this.failure});
}
