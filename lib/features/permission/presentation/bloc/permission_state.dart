part of 'permission_bloc.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object> get props => [];
}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionSuccess extends PermissionState {
  final String result;

  const PermissionSuccess({required this.result});
}

class PermissionError extends PermissionState {
  final Failure failure;

  const PermissionError({required this.failure});
}
