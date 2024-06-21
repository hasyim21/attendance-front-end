import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String note;
  final bool isCompleted;

  const Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.note,
    required this.isCompleted,
  });

  @override
  List<Object> get props {
    return [
      id,
      userId,
      title,
      note,
      isCompleted,
    ];
  }

  @override
  String toString() {
    return 'Note(id: $id, userId: $userId, title: $title, note: $note, isCompleted: $isCompleted)';
  }

  Note copyWith({
    int? id,
    int? userId,
    String? title,
    String? note,
    bool? isCompleted,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
