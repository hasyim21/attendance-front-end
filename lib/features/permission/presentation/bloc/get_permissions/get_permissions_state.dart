part of 'get_permissions_bloc.dart';

abstract class GetPermissionsState extends Equatable {
  const GetPermissionsState();

  @override
  List<Object> get props => [];
}

class GetPermissionsInitial extends GetPermissionsState {}

class GetPermissionsLoading extends GetPermissionsState {}

class GetPermissionsSuccess extends GetPermissionsState {
  final List<Permission> result;

  const GetPermissionsSuccess({required this.result});
}

class GetPermissionsError extends GetPermissionsState {
  final Failure failure;

  const GetPermissionsError({required this.failure});
}
