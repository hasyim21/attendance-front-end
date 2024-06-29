part of 'permissions_bloc.dart';

abstract class PermissionsEvent extends Equatable {
  const PermissionsEvent();

  @override
  List<Object> get props => [];
}

class GetPermissionsEvent extends PermissionsEvent {
  final int isApproved;

  const GetPermissionsEvent({required this.isApproved});
}

class RefreshPermissionsEvent extends PermissionsEvent {
  final int isApproved;

  const RefreshPermissionsEvent({required this.isApproved});
}
