part of 'update_note_bloc.dart';

class UpdateNoteEvent extends Equatable {
  final int id;
  final String title;
  final String note;
  final bool isCompleted;

  const UpdateNoteEvent({
    required this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [];
}
