import 'package:attendance_front_end/core/utils/failure/failure.dart';

import 'package:attendance_front_end/features/auth/domain/entities/user.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileLocalDatasource profileLocalDatasource;

  ProfileRepositoryImpl({required this.profileLocalDatasource});

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final result = await profileLocalDatasource.getUserProfile();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
