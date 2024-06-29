import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../domain/entities/note.dart';
import '../bloc/notes/notes_bloc.dart';
import '../bloc/update_note/update_note_bloc.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;

  const DetailNotePage({super.key, required this.note});

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _noteController.text = widget.note.note;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          MyTextField(
            controller: _titleController,
            label: 'Judul',
            maxLines: 2,
          ),
          const SpaceHeight(16.0),
          MyTextField(
            controller: _noteController,
            label: 'Note',
            maxLines: 5,
          ),
          const SpaceHeight(32.0),
          BlocListener<UpdateNoteBloc, UpdateNoteState>(
            listener: (context, state) {
              if (state is UpdateNoteLoading) {
                showDialogLoading(context);
              }
              if (state is UpdateNoteSuccess) {
                context.read<NotesBloc>().add(RefreshNotesEvent());
                context.popToRoot();
              }
            },
            child: MyButton.filled(
              onPressed: () {
                context.read<UpdateNoteBloc>().add(
                      UpdateNoteEvent(
                        id: widget.note.id,
                        title: _titleController.text,
                        note: _noteController.text,
                        isCompleted: widget.note.isCompleted,
                      ),
                    );
              },
              label: 'Simpan',
            ),
          ),
        ],
      ),
    );
  }
}
