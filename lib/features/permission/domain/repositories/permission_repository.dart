import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';

abstract class PermissionRepository {
  Future<Either<Failure, String>> addPermission(
      String image, String date, String reason);
}
