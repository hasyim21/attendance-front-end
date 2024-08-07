import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../core/styles/colors.dart';

class AttendanceButton extends StatelessWidget {
  final String label;
  final IconData iconPath;
  final String time;
  final Color buttonColor;
  final Color borderButtonColor;
  final VoidCallback onPressed;

  const AttendanceButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.time,
    required this.buttonColor,
    required this.borderButtonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: onPressed,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 68.0,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                width: 2.0,
                color: borderButtonColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white,
                      ),
                    ),
                    // SvgPicture.asset(
                    //   iconPath,
                    //   width: 24.0,
                    //   height: 24.0,
                    //   color: MyColors.white,
                    // ),
                    Icon(
                      iconPath,
                      color: MyColors.white,
                    ),
                  ],
                ),
                const SpaceHeight(4.0),
                Text(
                  label,
                  style: const TextStyle(
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
