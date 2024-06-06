part of 'add_permission_bloc.dart';

class AddPermissionEvent extends Equatable {
  final String image;
  final String date;
  final String reason;

  const AddPermissionEvent(
      {required this.image, required this.date, required this.reason});

  @override
  List<Object> get props => [];
}
