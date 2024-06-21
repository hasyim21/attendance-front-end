import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/usecases/delete_note.dart';

part 'delete_note_event.dart';
part 'delete_note_state.dart';

class DeleteNoteBloc extends Bloc<DeleteNoteEvent, DeleteNoteState> {
  final DeleteNote _deleteNote;
  DeleteNoteBloc(this._deleteNote) : super(DeleteNoteInitial()) {
    on<DeleteNoteEvent>((event, emit) async {
      emit(DeleteNoteLoading());

      final result = await _deleteNote.call(event.id);

      result.fold(
          (l) => emit(
                DeleteNoteError(
                  failure: Failure(message: l.message),
                ),
              ),
          (r) => emit(DeleteNoteSuccess(result: r)));
    });
  }
}
