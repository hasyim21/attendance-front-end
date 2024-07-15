import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/attendance.dart';

class AttendanceHistoryItem extends StatelessWidget {
  final Attendance data;

  const AttendanceHistoryItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91.0,
      padding: const EdgeInsets.all(12.0),
      decoration: const BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 67.0,
            width: 50.0,
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.date.toFormattedShortDate(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: MyColors.white,
                  ),
                ),
                Text(
                  data.date.toFormattedDay(),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: MyColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SpaceWidth(12.0),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_circle_down,
                          ),
                          const SpaceWidth(),
                          Text(data.timeIn?.toFormattedTime() ?? '-- : --'),
                        ],
                      ),
                      const SpaceHeight(),
                      const Text(
                        'Check In',
                        style: TextStyle(
                          color: MyColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 45.0,
                  child: VerticalDivider(
                    color: Colors.grey.shade300,
                    thickness: 1.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_circle_up,
                          ),
                          const SpaceWidth(),
                          Text(data.timeOut?.toFormattedTime() ?? '-- : --'),
                        ],
                      ),
                      const SpaceHeight(),
                      const Text(
                        'Check Out',
                        style: TextStyle(
                          color: MyColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
