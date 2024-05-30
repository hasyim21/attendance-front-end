import 'dart:convert';

import '../../domain/entities/auth.dart';
import 'user_model.dart';

class AuthModel extends Auth {
  final UserModel userModel;

  const AuthModel({
    required this.userModel,
    required super.token,
  }) : super(user: userModel);

  factory AuthModel.fromJson(String str) => AuthModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthModel.fromMap(Map<String, dynamic> json) => AuthModel(
        userModel: UserModel.fromMap(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toMap() => {
        "user": userModel.toMap(),
        "token": token,
      };

  @override
  List<Object> get props => [user, token];

  @override
  String toString() {
    return 'AuthModel(token: $token, id: $userModel.id, name: $userModel.name, email: $userModel.email, phone: $userModel.phone, role: $userModel.role, position: $userModel.position, department: $userModel.department, faceEmbedding: $userModel.faceEmbedding)';
  }
}
