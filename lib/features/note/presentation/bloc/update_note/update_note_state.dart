part of 'update_note_bloc.dart';

abstract class UpdateNoteState extends Equatable {
  const UpdateNoteState();

  @override
  List<Object> get props => [];
}

class UpdateNoteInitial extends UpdateNoteState {}

class UpdateNoteLoading extends UpdateNoteState {}

class UpdateNoteSuccess extends UpdateNoteState {
  final String result;

  const UpdateNoteSuccess({required this.result});
}

class UpdateNoteError extends UpdateNoteState {
  final Failure failure;

  const UpdateNoteError({required this.failure});
}
