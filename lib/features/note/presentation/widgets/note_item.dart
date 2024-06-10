import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class NoteItem extends StatelessWidget {
  final String title;
  final String note;

  const NoteItem({
    super.key,
    required this.title,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        MySnackbar.show(
          context,
          message: 'Catatan berhasil dihapus',
        );
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
      child: Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              note,
              style: const TextStyle(
                color: MyColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
