import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/auth_repository.dart';

class IsAuth {
  final AuthRepository authRepository;

  IsAuth({required this.authRepository});

  Future<Either<Failure, bool>> call() async {
    return await authRepository.isAuth();
  }
}
