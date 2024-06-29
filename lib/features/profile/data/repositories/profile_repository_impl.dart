import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepositoryImpl({required this.profileRemoteDatasource});

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final result = await profileRemoteDatasource.getUserProfile();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
