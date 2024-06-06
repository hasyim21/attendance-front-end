import 'package:flutter/material.dart';

import '../core.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.notifications,
      color: MyColors.white,
    );
  }
}
