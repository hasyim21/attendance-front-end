part of 'add_permission_bloc.dart';

abstract class AddPermissionState extends Equatable {
  const AddPermissionState();

  @override
  List<Object> get props => [];
}

class AddPermissionInitial extends AddPermissionState {}

class AddPermissionLoading extends AddPermissionState {}

class AddPermissionSuccess extends AddPermissionState {
  final String result;

  const AddPermissionSuccess({required this.result});
}

class AddPermissionError extends AddPermissionState {
  final Failure failure;

  const AddPermissionError({required this.failure});
}
