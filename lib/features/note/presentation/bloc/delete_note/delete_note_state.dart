part of 'delete_note_bloc.dart';

abstract class DeleteNoteState extends Equatable {
  const DeleteNoteState();

  @override
  List<Object> get props => [];
}

class DeleteNoteInitial extends DeleteNoteState {}

class DeleteNoteLoading extends DeleteNoteState {}

class DeleteNoteSuccess extends DeleteNoteState {
  final String result;

  const DeleteNoteSuccess({required this.result});
}

class DeleteNoteError extends DeleteNoteState {
  final Failure failure;

  const DeleteNoteError({required this.failure});
}
