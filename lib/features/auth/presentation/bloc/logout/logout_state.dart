part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final String result;

  const LogoutSuccess({required this.result});
}

class LogoutError extends LogoutState {
  final Failure failure;

  const LogoutError({required this.failure});
}
