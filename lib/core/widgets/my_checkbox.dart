import 'package:flutter/material.dart';

import '../core.dart';

class MyCheckbox extends StatelessWidget {
  final bool value;
  final Color activeColor;
  final ValueChanged<bool?> onChanged;

  const MyCheckbox({
    super.key,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Center(
        child: Icon(
          value ? Icons.check_box_rounded : Icons.check_box_outline_blank,
          color: MyColors.primary,
        ),
      ),
    );
  }
}
