part of 'update_face_embedding_bloc.dart';

abstract class UpdateFaceEmbeddingState extends Equatable {
  const UpdateFaceEmbeddingState();

  @override
  List<Object> get props => [];
}

class UpdateFaceEmbeddingInitial extends UpdateFaceEmbeddingState {}

class UpdateFaceEmbeddingLoading extends UpdateFaceEmbeddingState {}

class UpdateFaceEmbeddingSuccess extends UpdateFaceEmbeddingState {
  final FaceEmbedding result;

  const UpdateFaceEmbeddingSuccess({required this.result});
}

class UpdateFaceEmbeddingError extends UpdateFaceEmbeddingState {
  final Failure failure;

  const UpdateFaceEmbeddingError({required this.failure});
}
