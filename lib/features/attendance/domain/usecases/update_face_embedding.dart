import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/face_embedding.dart';
import '../repositories/attendance_repository.dart';

class UpdateFaceEmbedding {
  final AttendanceRepository attendanceRepository;

  UpdateFaceEmbedding({required this.attendanceRepository});

  Future<Either<Failure, FaceEmbedding>> call({
    required String faceEmbedding,
  }) async {
    return await attendanceRepository.updateFaceEmbedding(faceEmbedding);
  }
}
