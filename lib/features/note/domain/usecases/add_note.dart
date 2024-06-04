import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/note_repository.dart';

class AddNote {
  final NoteRepository noteRepository;

  AddNote({required this.noteRepository});

  Future<Either<Failure, String>> call(String title, String note) async {
    return await noteRepository.addNote(title, note);
  }
}
