import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../pages/location_page.dart';

class AttendanceHistoryItem extends StatelessWidget {
  final String statusAbsen;
  final bool isCheckIn;
  final String time;
  final String date;
  final double latitude;
  final double longitude;

  const AttendanceHistoryItem({
    super.key,
    required this.statusAbsen,
    this.isCheckIn = true,
    required this.time,
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopWidget(
          statusAbsen: statusAbsen,
          isCheckIn: isCheckIn,
          time: time,
          date: date,
        ),
        const SpaceHeight(),
        BottomWidget(
          isCheckIn: isCheckIn,
          longitude: longitude,
          latitude: latitude,
        ),
      ],
    );
  }
}

class TopWidget extends StatelessWidget {
  const TopWidget({
    super.key,
    required this.isCheckIn,
    required this.statusAbsen,
    required this.time,
    required this.date,
  });

  final bool isCheckIn;
  final String statusAbsen;
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isCheckIn ? MyColors.primary : MyColors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusAbsen,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: MyColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          const SpaceHeight(4.0),
          Row(
            children: [
              const Icon(
                Icons.location_history,
              ),
              const SpaceWidth(8.0),
              const Text(
                'Kantor',
                style: TextStyle(
                  color: MyColors.white,
                ),
              ),
              const Spacer(),
              Text(
                date.substring(0, 10),
                style: const TextStyle(
                  color: MyColors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  const BottomWidget({
    super.key,
    required this.isCheckIn,
    required this.longitude,
    required this.latitude,
  });

  final bool isCheckIn;
  final double longitude;
  final double latitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isCheckIn ? MyColors.primary : MyColors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_history,
              ),
              SpaceWidth(8.0),
              Text(
                'Kantor',
                style: TextStyle(
                  fontSize: 16.0,
                  color: MyColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SpaceHeight(4.0),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  color: MyColors.white,
                ),
              ),
              Text(
                'Sesuai spot Absensi',
                style: TextStyle(
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          const SpaceHeight(4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Longitude',
                style: TextStyle(
                  color: MyColors.white,
                ),
              ),
              Text(
                longitude.toString(),
                style: const TextStyle(
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          const SpaceHeight(4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latitude',
                style: TextStyle(
                  color: MyColors.white,
                ),
              ),
              Text(
                latitude.toString(),
                style: const TextStyle(
                  color: MyColors.white,
                ),
              ),
            ],
          ),
          const SpaceHeight(12.0),
          Button.filled(
            color: MyColors.white.withOpacity(0.5),
            onPressed: () {
              context.push(
                LocationPage(
                  latitude: latitude,
                  longitude: longitude,
                ),
              );
            },
            label: 'Lihat di Peta',
            fontSize: 14.0,
            height: 40.0,
          ),
        ],
      ),
    );
  }
}
