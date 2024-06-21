import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/permission.dart';

abstract class PermissionRepository {
  Future<Either<Failure, String>> addPermission(
    String image,
    String startDate,
    String endDate,
    String reason,
  );
  Future<Either<Failure, List<Permission>>> getPermissions(int isApproved);
}
