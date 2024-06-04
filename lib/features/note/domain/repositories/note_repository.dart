import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/note.dart';

abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, String>> addNote(String title, String note);
}
