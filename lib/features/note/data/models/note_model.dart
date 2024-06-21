import 'dart:convert';

import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.note,
    required super.isCompleted,
  });

  factory NoteModel.fromJson(String str) => NoteModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        userId: json["user_id"],
        title: json["title"],
        note: json["note"],
        isCompleted: json['is_completed'] == 0 ? false : true,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "note": note,
        "is_completed": isCompleted,
      };

  @override
  List<Object> get props => [
        id,
        userId,
        title,
        note,
        isCompleted,
      ];

  @override
  String toString() {
    return 'Note(id: $id, userId: $userId, title: $title, note: $note, isCompleted: $isCompleted)';
  }
}
