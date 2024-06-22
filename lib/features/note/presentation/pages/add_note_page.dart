import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../bloc/add_note/add_note_bloc.dart';
import '../bloc/get_notes/get_notes_bloc.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
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
        title: const Text('Tambah Catatan'),
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
          BlocListener<AddNoteBloc, AddNoteState>(
            listener: (context, state) {
              if (state is AddNoteLoading) {
                showDialogLoading(context);
              }
              if (state is AddNoteSuccess) {
                context.read<GetNotesBloc>().add(const GetNotesEvent());
                context.popToRoot();
              }
            },
            child: MyButton.filled(
              onPressed: () {
                context.read<AddNoteBloc>().add(
                      AddNoteEvent(
                        title: _titleController.text,
                        note: _noteController.text,
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
