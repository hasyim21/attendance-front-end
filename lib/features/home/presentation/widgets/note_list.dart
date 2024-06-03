import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import 'note_item.dart';

class NoteList extends StatelessWidget {
  const NoteList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Catatan",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.add,
              ),
            ],
          ),
        ),
        const SpaceHeight(16.0),
        ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          itemCount: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const NoteItem(
              title: 'Meeting penting',
              note: 'Jam 10:00 AM',
            );
          },
          separatorBuilder: (context, index) => const SpaceHeight(),
        ),
      ],
    );
  }
}
