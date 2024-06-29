import 'package:flutter/material.dart';

class BottomLoading extends StatelessWidget {
  const BottomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      ),
    );
  }
}
