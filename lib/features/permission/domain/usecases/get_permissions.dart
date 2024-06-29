import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/permission.dart';
import '../repositories/permission_repository.dart';

class GetPermissions {
  final PermissionRepository _permissionRepository;

  GetPermissions(this._permissionRepository);

  Future<Either<Failure, List<Permission>>> call({
    required int isApproved,
    required int page,
    required int perPage,
  }) async {
    return await _permissionRepository.getPermissions(
      isApproved,
      page,
      perPage,
    );
  }
}
