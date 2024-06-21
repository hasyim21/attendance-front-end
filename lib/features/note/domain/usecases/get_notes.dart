import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';

class GetNotes {
  final NoteRepository _noteRepository;

  GetNotes(this._noteRepository);

  Future<Either<Failure, List<Note>>> call() async {
    return await _noteRepository.getNotes();
  }
}
