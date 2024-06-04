part of 'add_note_bloc.dart';

abstract class AddNoteState extends Equatable {
  const AddNoteState();

  @override
  List<Object> get props => [];
}

class AddNoteInitial extends AddNoteState {}

class AddNoteLoading extends AddNoteState {}

class AddNoteSuccess extends AddNoteState {
  final String result;

  const AddNoteSuccess({required this.result});
}

class AddNoteError extends AddNoteState {
  final Failure failure;

  const AddNoteError({required this.failure});
}
