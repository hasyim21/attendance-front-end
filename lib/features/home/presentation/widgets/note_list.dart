import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../note/presentation/bloc/delete_note/delete_note_bloc.dart';
import '../../../note/presentation/bloc/notes/notes_bloc.dart';
import '../../../note/presentation/widgets/note_item.dart';

class NoteList extends StatefulWidget {
  const NoteList({
    super.key,
  });

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollEvent);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollEvent)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteNoteBloc, DeleteNoteState>(
      listener: (context, state) {
        if (state is DeleteNoteSuccess) {
          MySnackbar.show(
            context,
            message: 'Catatan berhasil dihapus',
          );
        }
      },
      child: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          switch (state.status) {
            case NotesStatus.failure:
              return Center(
                child: Text(state.message),
              );
            case NotesStatus.success:
              if (state.notes.isEmpty) {
                return const Center(
                  child: Text('Tidak ada catatan'),
                );
              }
              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: (state.hasReachedMax ||
                          state.notes.length < state.perPage)
                      ? state.notes.length
                      : state.notes.length + 1,
                  itemBuilder: (context, index) {
                    if (index < state.notes.length) {
                      final note = state.notes[index];
                      return NoteItem(note: note);
                    } else {
                      return const BottomLoading();
                    }
                  },
                  separatorBuilder: (context, index) => const SpaceHeight(),
                ),
              );
            case NotesStatus.initial:
              return const Expanded(
                child: ShimmerVerticalLoading(
                  height: 64.0,
                  isScrolled: true,
                  usePadding: false,
                ),
              );
          }
        },
      ),
    );
  }

  void _scrollEvent() {
    if (_isBottom) context.read<NotesBloc>().add(GetNotesEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll == maxScroll;
  }
}
