import 'package:attendance_front_end/features/note/domain/repositories/note_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';

class UpdateNote {
  final NoteRepository _noteRepository;

  UpdateNote(this._noteRepository);

  Future<Either<Failure, String>> call(
    int id,
    String title,
    String note,
    bool isCompleted,
  ) async {
    return await _noteRepository.updateNote(id, title, note, isCompleted);
  }
}
