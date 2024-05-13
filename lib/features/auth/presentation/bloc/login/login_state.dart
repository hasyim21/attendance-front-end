part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Auth result;

  const LoginSuccess({required this.result});
}

class LoginError extends LoginState {
  final Failure failure;

  const LoginError({required this.failure});
}
