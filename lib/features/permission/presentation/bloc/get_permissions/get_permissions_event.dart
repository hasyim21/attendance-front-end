part of 'get_permissions_bloc.dart';

class GetPermissionsEvent extends Equatable {
  final int isApproved;

  const GetPermissionsEvent({required this.isApproved});

  @override
  List<Object> get props => [];
}
