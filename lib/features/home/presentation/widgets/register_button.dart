import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../attendance/presentation/pages/register_face_page.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Button.filled(
      onPressed: () {
        showBottomSheet(
          backgroundColor: MyColors.white,
          context: context,
          builder: (context) => Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 60.0,
                  height: 8.0,
                  child: Divider(color: MyColors.lightSheet),
                ),
                const CloseButton(),
                const Center(
                  child: Text(
                    'Oops !',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                const SpaceHeight(4.0),
                const Center(
                  child: Text(
                    'Aplikasi ingin mengakses Kamera',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SpaceHeight(36.0),
                Button.filled(
                  onPressed: () => context.pop(),
                  label: 'Tolak',
                  color: MyColors.secondary,
                ),
                const SpaceHeight(16.0),
                Button.filled(
                  onPressed: () {
                    context.pop();
                    context.push(const RegisterFacePage());
                  },
                  label: 'Izinkan',
                ),
              ],
            ),
          ),
        );
      },
      label: 'Attendance Using Face ID',
      icon: Assets.icons.attendance.svg(),
    );
  }
}
