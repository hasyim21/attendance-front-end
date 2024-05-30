import 'package:flutter/material.dart';

class SpaceHeight extends StatelessWidget {
  final double height;
  const SpaceHeight([this.height = 8.0, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class SpaceWidth extends StatelessWidget {
  final double width;
  const SpaceWidth([this.width = 8.0, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
