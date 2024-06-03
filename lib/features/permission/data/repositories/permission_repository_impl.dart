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
    String date,
    String reason,
  ) async {
    try {
      final result =
          await permissionRemoteDatasource.addPermission(image, date, reason);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
