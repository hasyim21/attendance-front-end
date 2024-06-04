part of 'add_note_bloc.dart';

class AddNoteEvent extends Equatable {
  final String title;
  final String note;

  const AddNoteEvent({required this.title, required this.note});

  @override
  List<Object> get props => [];
}
