import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ProfileMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenu({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon),
            const SpaceWidth(),
            Text(title),
            const Spacer(),
            (onTap != null)
                ? const Icon(
                    Icons.arrow_forward_ios,
                    size: 12.0,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
