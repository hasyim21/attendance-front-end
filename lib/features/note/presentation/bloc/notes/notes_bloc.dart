import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/note.dart';
import '../../../domain/usecases/get_notes.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotes _getNotes;
  NotesBloc(this._getNotes) : super(NotesState.initial()) {
    on<GetNotesEvent>((event, emit) async {
      if (state.hasReachedMax) return;

      if (state.status == NotesStatus.initial) {
        final notes = await _getNotes.call(
          page: state.page,
          perPage: state.perPage,
        );
        notes.fold(
          (failure) => emit(
            state.copyWith(
              status: NotesStatus.failure,
              message: failure.message,
            ),
          ),
          (notes) => emit(
            state.copyWith(
              status: NotesStatus.success,
              notes: notes,
              page: state.page + 1,
              hasReachedMax: notes.isEmpty,
            ),
          ),
        );
      }

      final notes = await _getNotes.call(
        page: state.page,
        perPage: state.perPage,
      );

      notes.fold(
        (failure) => emit(
          state.copyWith(
            status: NotesStatus.failure,
            message: failure.message,
          ),
        ),
        (notes) {
          if (notes.isEmpty) {
            emit(state.copyWith(hasReachedMax: true));
          } else {
            emit(
              state.copyWith(
                status: NotesStatus.success,
                notes: List.of(state.notes)..addAll(notes),
                page: state.page + 1,
                hasReachedMax: false,
              ),
            );
          }
        },
      );
    });

    on<RefreshNotesEvent>((event, emit) async {
      emit(NotesState.initial());

      if (state.status == NotesStatus.initial) {
        final notes = await _getNotes.call(
          page: state.page,
          perPage: state.perPage,
        );
        notes.fold(
          (failure) => emit(
            state.copyWith(
              status: NotesStatus.failure,
              message: failure.message,
            ),
          ),
          (notes) => emit(
            state.copyWith(
              status: NotesStatus.success,
              notes: notes,
              page: state.page + 1,
              hasReachedMax: notes.isEmpty,
            ),
          ),
        );
      }
    });
  }
}
