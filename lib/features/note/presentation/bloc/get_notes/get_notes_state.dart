part of 'get_notes_bloc.dart';

abstract class GetNotesState extends Equatable {
  const GetNotesState();

  @override
  List<Object> get props => [];
}

class GetNotesInitial extends GetNotesState {}

class GetNotesLoading extends GetNotesState {}

class GetNotesSuccess extends GetNotesState {
  final List<Note> result;

  const GetNotesSuccess({required this.result});
}

class GetNotesError extends GetNotesState {
  final Failure failure;

  const GetNotesError({required this.failure});
}
