import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String note;

  const Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.note,
  });

  @override
  List<Object> get props => [id, userId, title, note];

  @override
  String toString() {
    return 'Note(id: $id, userId: $userId, title: $title, note: $note)';
  }
}
