import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/permission.dart';

class PermissionItem extends StatelessWidget {
  final Permission permission;

  const PermissionItem({super.key, required this.permission});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: _getStatusColor(permission.isApproved),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        permission.reason,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(permission.datePermission),
                    ],
                  ),
                  Container(
                    height: 25.0,
                    width: 60.0,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: _getStatusColor(permission.isApproved),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getApprovalStatus(permission.isApproved),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int isApproved) {
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
