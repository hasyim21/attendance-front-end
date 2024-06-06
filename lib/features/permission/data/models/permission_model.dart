import 'dart:convert';

import '../../domain/entities/permission.dart';

class PermissionModel extends Permission {
  const PermissionModel({
    required super.id,
    required super.userId,
    required super.datePermission,
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
        datePermission: json["date_permission"],
        reason: json["reason"],
        image: json["image"],
        isApproved: json["is_approved"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "date_permission": datePermission,
        "reason": reason,
        "image": image,
        "is_approved": isApproved,
      };
}
