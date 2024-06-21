import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/permission.dart';
import '../pages/detail_permission_page.dart';

class PermissionItem extends StatelessWidget {
  final Permission permission;

  const PermissionItem({super.key, required this.permission});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        DetailPermissionPage(permission: permission),
      ),
      child: Container(
        height: 109.0,
        padding: const EdgeInsets.all(12.0),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tanggal',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: MyColors.grey,
                      ),
                    ),
                    const SpaceHeight(4.0),
                    Text(
                      '${permission.startDate.toFormattedDate()} ${permission.endDate.isEmpty ? '' : '- ${permission.endDate.toFormattedDate()}'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 25.0,
                  width: 60.0,
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: _getBackgroundColor(permission.isApproved),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getApprovalStatus(permission.isApproved),
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: _getFontColor(permission.isApproved),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SpaceHeight(12.0),
            const MyDivider(thickness: 1.0),
            const SpaceHeight(12.0),
            Text(
              permission.reason,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(int isApproved) {
    if (isApproved == 0) {
      return MyColors.red.withOpacity(0.2);
    } else if (isApproved == 1) {
      return MyColors.green.withOpacity(0.2);
    } else if (isApproved == 2) {
      return MyColors.yellow.withOpacity(0.2);
    } else {
      return MyColors.white;
    }
  }

  Color _getFontColor(int isApproved) {
    if (isApproved == 0) {
      return MyColors.red;
    } else if (isApproved == 1) {
      return MyColors.green;
    } else if (isApproved == 2) {
      return MyColors.yellow;
    } else {
      return MyColors.white;
    }
  }

  String _getApprovalStatus(int isApproved) {
    if (isApproved == 0) {
      return 'Ditolak';
    } else if (isApproved == 1) {
      return 'Disetujui';
    } else if (isApproved == 2) {
      return 'Diproses';
    } else {
      return 'Status Tidak Diketahui';
    }
  }
}
