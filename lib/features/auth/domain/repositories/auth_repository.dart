import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/auth.dart';

abstract class AuthRepository {
  Future<Either<Failure, Auth>> login(String email, String password);
  Future<Either<Failure, String>> logout();
  Future<Either<Failure, bool>> isAuth();
}
