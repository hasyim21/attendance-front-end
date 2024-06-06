import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/permission.dart';

abstract class PermissionRepository {
  Future<Either<Failure, String>> addPermission(
    String image,
    String date,
    String reason,
  );
  Future<Either<Failure, List<Permission>>> getPermissions();
}
