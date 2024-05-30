import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../domain/entities/face_embedding.dart';
import '../../../domain/usecases/update_face_embedding.dart';

part 'update_face_embedding_event.dart';
part 'update_face_embedding_state.dart';

class UpdateFaceEmbeddingBloc
    extends Bloc<UpdateFaceEmbeddingEvent, UpdateFaceEmbeddingState> {
  final UpdateFaceEmbedding updateFaceEmbedding;
  final AuthLocalDatasource authLocalDatasource;

  UpdateFaceEmbeddingBloc(
      {required this.updateFaceEmbedding, required this.authLocalDatasource})
      : super(UpdateFaceEmbeddingInitial()) {
    on<UpdateFaceEmbeddingEvent>((event, emit) async {
      emit(UpdateFaceEmbeddingLoading());

      final result = await updateFaceEmbedding.call(
        faceEmbedding: event.faceEmbedding,
      );

      result.fold(
        (l) => emit(
          UpdateFaceEmbeddingError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) async {
          emit(UpdateFaceEmbeddingSuccess(result: r));
          await authLocalDatasource.updateFaceEmbedding(r.user.faceEmbedding);
        },
      );
    });
  }
}
