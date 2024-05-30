part of 'update_face_embedding_bloc.dart';

class UpdateFaceEmbeddingEvent extends Equatable {
  final String faceEmbedding;

  const UpdateFaceEmbeddingEvent({required this.faceEmbedding});

  @override
  List<Object> get props => [faceEmbedding];
}
