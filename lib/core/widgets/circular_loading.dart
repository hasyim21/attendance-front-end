import 'package:flutter/material.dart';

import '../core.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: MyColors.primary,
    );
  }
}
