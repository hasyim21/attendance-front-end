import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository profileRepository;

  GetUserProfile({required this.profileRepository});

  Future<Either<Failure, User>> call() async {
    return await profileRepository.getUserProfile();
  }
}
