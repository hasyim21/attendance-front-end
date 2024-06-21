import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../note/presentation/bloc/delete_note/delete_note_bloc.dart';
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
        Row(
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
        const SpaceHeight(16.0),
        BlocListener<DeleteNoteBloc, DeleteNoteState>(
          listener: (context, state) {
            if (state is DeleteNoteSuccess) {
              MySnackbar.show(
                context,
                message: 'Catatan berhasil dihapus',
              );
            }
          },
          child: BlocBuilder<GetNotesBloc, GetNotesState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case GetNotesError:
                  final errorState = state as GetNotesError;
                  return Center(
                    child: Text(errorState.failure.message),
                  );
                case GetNotesLoading:
                  return const ShimmerVerticalLoading(
                    height: 64.0,
                    isScrolled: false,
                    usePadding: false,
                  );
                case GetNotesSuccess:
                  final successState = state as GetNotesSuccess;
                  if (successState.result.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada catatan'),
                    );
                  }
                  return ListView.separated(
                    itemCount: successState.result.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final note = successState.result[index];
                      return NoteItem(note: note);
                    },
                    separatorBuilder: (context, index) => const SpaceHeight(),
                  );
                default:
                  return const Center(
                    child: Text('Tidak ada catatan'),
                  );
              }
            },
          ),
        ),
      ],
    );
  }
}
