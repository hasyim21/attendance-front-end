import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository authRepository;

  Logout({required this.authRepository});

  Future<Either<Failure, String>> call() async {
    return await authRepository.logout();
  }
}
