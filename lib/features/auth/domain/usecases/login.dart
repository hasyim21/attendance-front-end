import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/auth.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository authRepository;

  Login({required this.authRepository});

  Future<Either<Failure, Auth>> call({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(email, password);
  }
}
