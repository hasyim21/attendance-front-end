part of 'notes_bloc.dart';

enum NotesStatus { initial, success, failure }

class NotesState extends Equatable {
  final NotesStatus status;
  final List<Note> notes;
  final int page;
  final int perPage;
  final bool hasReachedMax;
  final String message;

  const NotesState({
    required this.status,
    required this.notes,
    required this.page,
    required this.perPage,
    required this.hasReachedMax,
    required this.message,
  });

  factory NotesState.initial() {
    return const NotesState(
      status: NotesStatus.initial,
      notes: [],
      page: 1,
      perPage: 10,
      hasReachedMax: false,
      message: '',
    );
  }

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    int? page,
    int? perPage,
    bool? hasReachedMax,
    String? message,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      notes,
      page,
      perPage,
      hasReachedMax,
      message,
    ];
  }
}
