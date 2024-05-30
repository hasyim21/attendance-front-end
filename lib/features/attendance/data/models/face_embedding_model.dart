import 'dart:convert';

import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/face_embedding.dart';

class FaceEmbeddingModel extends FaceEmbedding {
  final UserModel userModel;

  const FaceEmbeddingModel({
    required this.userModel,
  }) : super(user: userModel);

  factory FaceEmbeddingModel.fromJson(String str) =>
      FaceEmbeddingModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FaceEmbeddingModel.fromMap(Map<String, dynamic> json) =>
      FaceEmbeddingModel(
        userModel: UserModel.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "user": userModel.toMap(),
      };

  @override
  List<Object> get props => [user];
}
