part of 'add_permission_bloc.dart';

class AddPermissionEvent extends Equatable {
  final String image;
  final String startDate;
  final String endDate;
  final String reason;

  const AddPermissionEvent({
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  @override
  List<Object> get props => [];
}
