import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/note_repository.dart';

class DeleteNote {
  final NoteRepository _noteRepository;

  DeleteNote(this._noteRepository);

  Future<Either<Failure, String>> call(int id) async {
    return await _noteRepository.deleteNote(id);
  }
}
