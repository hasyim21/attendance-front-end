import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../note/presentation/bloc/get_notes/get_notes_bloc.dart';
import '../../../note/presentation/pages/add_note_page.dart';
import '../../../note/presentation/widgets/note_item.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Catatan",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MyIconButton(
                onTap: () => context.push(const AddNotePage()),
                icon: Icons.add,
              ),
            ],
          ),
        ),
        const SpaceHeight(16.0),
        BlocBuilder<GetNotesBloc, GetNotesState>(
          builder: (context, state) {
            if (state is GetNotesError) {
              return Center(
                child: Text(state.failure.message),
              );
            }
            if (state is GetNotesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is GetNotesSuccess) {
              if (state.result.isEmpty) {
                return const Center(
                  child: Text('Tidak ada catatan'),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: state.result.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final note = state.result[index];
                  return NoteItem(
                    title: note.title,
                    note: note.note,
                  );
                },
                separatorBuilder: (context, index) => const SpaceHeight(),
              );
            }

            return const Center(
              child: Text('Tidak ada catatan'),
            );
          },
        ),
      ],
    );
  }
}
