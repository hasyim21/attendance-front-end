import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/permission_repository.dart';

class AddPermission {
  final PermissionRepository permissionRepository;

  AddPermission({
    required this.permissionRepository,
  });

  Future<Either<Failure, String>> call({
    required String image,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    return await permissionRepository.addPermission(
      image,
      startDate,
      endDate,
      reason,
    );
  }
}
