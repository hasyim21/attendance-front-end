import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  final double? thickness;
  final Color? color;

  const MyDivider({
    super.key,
    this.thickness,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? Colors.grey.shade200,
      height: 0.0,
      thickness: thickness ?? 0.5,
    );
  }
}
