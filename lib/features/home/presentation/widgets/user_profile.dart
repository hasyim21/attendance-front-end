import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../profile/presentation/bloc/bloc/get_user_profile_bloc.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    User? user;
    return BlocBuilder<GetUserProfileBloc, GetUserProfileState>(
      builder: (context, state) {
        if (state is GetUserProfileSuccess) {
          user = state.result;
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? '-',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: MyColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                Text(
                  user?.position ?? '-',
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
              backgroundImage: (user?.imageUrl != null)
                  ? NetworkImage('$urlProfileImage${user?.imageUrl}')
                  : null,
            ),
          ],
        );
      },
    );
  }
}
