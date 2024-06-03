part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class AddPermissionEvent extends PermissionEvent {
  final String image;
  final String date;
  final String reason;

  const AddPermissionEvent(
      {required this.image, required this.date, required this.reason});
}
