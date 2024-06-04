import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure/failure.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_datasource.dart';

class NoteRepositoryImpl extends NoteRepository {
  final NoteRemoteDatasourceImpl noteRemoteDatasource;

  NoteRepositoryImpl({required this.noteRemoteDatasource});

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final result = await noteRemoteDatasource.getNotes();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addNote(String title, String note) async {
    try {
      final result = await noteRemoteDatasource.addNote(title, note);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
