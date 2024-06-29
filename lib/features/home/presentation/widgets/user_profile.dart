import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../profile/presentation/bloc/get_user_profile/get_user_profile_bloc.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserProfileBloc, GetUserProfileState>(
      builder: (context, state) {
        if (state is GetUserProfileSuccess) {
          final user = state.result;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: MyColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                  Text(
                    user.position,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: MyColors.white,
                    ),
                  ),
                ],
              ),
              const SpaceWidth(),
              CircleAvatar(
                backgroundColor: MyColors.white,
                backgroundImage:
                    NetworkImage('$urlProfileImage${user.imageUrl}'),
              ),
            ],
          );
        }
        return const _InitialUserProfile();
      },
    );
  }
}

class _InitialUserProfile extends StatelessWidget {
  const _InitialUserProfile();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '-',
              style: TextStyle(
                fontSize: 18.0,
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            Text(
              '-',
              style: TextStyle(
                fontSize: 12.0,
                color: MyColors.white,
              ),
            ),
          ],
        ),
        SpaceWidth(),
        CircleAvatar(
          backgroundColor: MyColors.white,
          child: Icon(
            Icons.person,
            color: MyColors.black,
          ),
        ),
      ],
    );
  }
}
