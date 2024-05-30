import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          backgroundColor: MyColors.white,
        ),
        SpaceWidth(8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lebron James',
              style: TextStyle(
                fontSize: 18.0,
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 12.0,
                color: MyColors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
