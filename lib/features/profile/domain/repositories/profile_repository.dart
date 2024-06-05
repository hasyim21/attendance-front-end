import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getUserProfile();
}
