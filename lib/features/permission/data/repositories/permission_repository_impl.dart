import 'package:attendance_front_end/features/permission/domain/entities/permission.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure/failure.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_remote_datasource.dart';

class PermissionRepositoryImpl extends PermissionRepository {
  final PermissionRemoteDatasource permissionRemoteDatasource;

  PermissionRepositoryImpl({required this.permissionRemoteDatasource});

  @override
  Future<Either<Failure, String>> addPermission(
    String image,
    String startDate,
    String endDate,
    String reason,
  ) async {
    try {
      final result = await permissionRemoteDatasource.addPermission(
        image,
        startDate,
        endDate,
        reason,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Permission>>> getPermissions(
      int isApproved) async {
    try {
      final result =
          await permissionRemoteDatasource.getPermissions(isApproved);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
