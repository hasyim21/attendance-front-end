import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure/failure.dart';
import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  final AuthLocalDatasource authLocalDatasource;

  AuthRepositoryImpl({
    required this.authRemoteDatasource,
    required this.authLocalDatasource,
  });

  @override
  Future<Either<Failure, Auth>> login(String email, String password) async {
    try {
      final result = await authRemoteDatasource.login(email, password);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final result = await authRemoteDatasource.logout();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuth() async {
    try {
      final result = await authLocalDatasource.isAuth();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
