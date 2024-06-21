import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/note.dart';
import '../bloc/delete_note/delete_note_bloc.dart';
import '../bloc/update_note/update_note_bloc.dart';
import '../pages/detail_note_page.dart';

class NoteItem extends StatefulWidget {
  final Note note;

  const NoteItem({
    super.key,
    required this.note,
  });

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  late Note _note;

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  void _toggleCompleted(bool? value) {
    setState(() {
      _note = _note.copyWith(isCompleted: value ?? false);
    });
    context.read<UpdateNoteBloc>().add(
          UpdateNoteEvent(
            id: _note.id,
            title: _note.title,
            note: _note.note,
            isCompleted: _note.isCompleted,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        context.read<DeleteNoteBloc>().add(DeleteNoteEvent(id: _note.id));
      },
      background: Container(
        color: MyColors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8.0),
        child: const Icon(
          Icons.delete,
          color: MyColors.white,
        ),
      ),
      child: GestureDetector(
        onTap: () => context.push(
          DetailNotePage(note: _note),
        ),
        child: Container(
          height: 64.0,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _note.note,
                      style: const TextStyle(
                        color: MyColors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              MyCheckbox(
                value: _note.isCompleted,
                activeColor: MyColors.primary,
                onChanged: _toggleCompleted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
