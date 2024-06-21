import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/permission.dart';
import '../repositories/permission_repository.dart';

class GetPermissions {
  final PermissionRepository _permissionRepository;

  GetPermissions(this._permissionRepository);

  Future<Either<Failure, List<Permission>>> call(int isApproved) async {
    return await _permissionRepository.getPermissions(isApproved);
  }
}
