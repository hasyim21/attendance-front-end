import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/usecases/get_notes.dart';

part 'get_notes_event.dart';
part 'get_notes_state.dart';

class GetNotesBloc extends Bloc<GetNotesEvent, GetNotesState> {
  final GetNotes _getNotes;

  GetNotesBloc(this._getNotes) : super(GetNotesInitial()) {
    on<GetNotesEvent>((event, emit) async {
      emit(GetNotesLoading());

      final result = await _getNotes.call();

      result.fold(
        (l) => emit(
          GetNotesError(
            failure: Failure(message: l.message),
          ),
        ),
        (r) => emit(GetNotesSuccess(result: r)),
      );
    });
  }
}
