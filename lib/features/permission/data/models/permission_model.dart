import 'dart:convert';

import '../../domain/entities/permission.dart';

class PermissionModel extends Permission {
  const PermissionModel({
    required super.id,
    required super.userId,
    required super.startDate,
    required super.endDate,
    required super.reason,
    required super.image,
    required super.isApproved,
  });
  factory PermissionModel.fromJson(String str) =>
      PermissionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PermissionModel.fromMap(Map<String, dynamic> json) => PermissionModel(
        id: json["id"],
        userId: json["user_id"],
        startDate: json["start_date"],
        endDate: json["end_date"] ?? '',
        reason: json["reason"],
        image: json["image"],
        isApproved: json["is_approved"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "start_date": startDate,
        "end_date": endDate,
        "reason": reason,
        "image": image,
        "is_approved": isApproved,
      };

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
}
