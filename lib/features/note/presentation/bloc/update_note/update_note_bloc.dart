import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/usecases/update_note.dart';

part 'update_note_event.dart';
part 'update_note_state.dart';

class UpdateNoteBloc extends Bloc<UpdateNoteEvent, UpdateNoteState> {
  final UpdateNote _updateNote;
  UpdateNoteBloc(this._updateNote) : super(UpdateNoteInitial()) {
    on<UpdateNoteEvent>((event, emit) async {
      emit(UpdateNoteLoading());

      final result = await _updateNote.call(
          event.id, event.title, event.note, event.isCompleted);

      result.fold(
          (l) => emit(
                UpdateNoteError(
                  failure: Failure(message: l.message),
                ),
              ),
          (r) => emit(UpdateNoteSuccess(result: r)));
    });
  }
}
