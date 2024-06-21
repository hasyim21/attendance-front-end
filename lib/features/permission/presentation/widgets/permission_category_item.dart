import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class PermissionCategoryItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PermissionCategoryItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.primary : MyColors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? MyColors.white : MyColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
