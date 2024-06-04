import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/usecases/add_note.dart';

part 'add_note_event.dart';
part 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final AddNote _addNote;

  AddNoteBloc(this._addNote) : super(AddNoteInitial()) {
    on<AddNoteEvent>((event, emit) async {
      emit(AddNoteLoading());

      final result = await _addNote.call(event.title, event.note);

      result.fold(
        (l) => emit(
          AddNoteError(
            failure: Failure(message: l.message),
          ),
        ),
        (r) => emit(AddNoteSuccess(result: r)),
      );
    });
  }
}
