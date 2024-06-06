import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  final int id;
  final int userId;
  final String datePermission;
  final String reason;
  final String image;
  final int isApproved;

  const Permission({
    required this.id,
    required this.userId,
    required this.datePermission,
    required this.reason,
    required this.image,
    required this.isApproved,
  });

  @override
  List<Object> get props {
    return [
      id,
      userId,
      datePermission,
      reason,
      image,
      isApproved,
    ];
  }

  @override
  String toString() {
    return 'Permission(id: $id, userId: $userId, datePermission: $datePermission, reason: $reason, image: $image, isApproved: $isApproved)';
  }
}
