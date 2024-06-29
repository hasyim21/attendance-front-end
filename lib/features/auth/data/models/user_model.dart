import 'dart:convert';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.role,
    required super.position,
    required super.department,
    required super.faceEmbedding,
    required super.imageUrl,
    required super.timeIn,
    required super.timeOut,
  });

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        position: json["position"],
        department: json["department"],
        faceEmbedding: json["face_embedding"],
        imageUrl: json["image_url"],
        timeIn: json["time_in"],
        timeOut: json["time_out"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "position": position,
        "department": department,
        "face_embedding": faceEmbedding,
        "image_url": imageUrl,
        "time_in": timeIn,
        "time_out": timeOut,
      };

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? position,
    String? department,
    String? faceEmbedding,
    String? imageUrl,
    String? timeIn,
    String? timeOut,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      position: position ?? this.position,
      department: department ?? this.department,
      faceEmbedding: faceEmbedding ?? this.faceEmbedding,
      imageUrl: imageUrl ?? this.imageUrl,
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
    );
  }

  factory UserModel.initial() {
    return const UserModel(
      id: 0,
      name: '-',
      email: '-',
      phone: '-',
      role: '-',
      position: '-',
      department: '-',
      faceEmbedding: null,
      imageUrl: '-',
      timeIn: '-',
      timeOut: '-',
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      phone,
      role,
      position,
      department,
      faceEmbedding,
      imageUrl,
      timeIn,
      timeOut,
    ];
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, role: $role, position: $position, department: $department, faceEmbedding: $faceEmbedding, imageUrl: $imageUrl, timeIn: $timeIn, timeOut: $timeOut)';
  }
}
