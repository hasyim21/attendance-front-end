import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final int id;
  final int userId;
  final String startDate;
  final String endDate;
  final String reason;
  final String image;
  final int isApproved;

  const Permission({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.image,
    required this.isApproved,
  });

  @override
  List<Object> get props {
    return [
      id,
      userId,
      startDate,
      endDate,
      reason,
      image,
      isApproved,
    ];
  }

  @override
  String toString() {
    return 'Permission(id: $id, userId: $userId, startDate: $startDate, endDate: $endDate, reason: $reason, image: $image, isApproved: $isApproved)';
  }
}
