import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/attendance.dart';
import '../entities/attendance_status.dart';
import '../entities/company.dart';
import '../entities/face_embedding.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, FaceEmbedding>> updateFaceEmbedding(
    String faceEmbedding,
  );
  Future<Either<Failure, Company>> getCompany();
  Future<Either<Failure, Attendance>> checkIn(
    String latitude,
    String longitude,
  );
  Future<Either<Failure, Attendance>> checkOut(
    String latitude,
    String longitude,
  );
  Future<Either<Failure, AttendanceStatus>> checkAttendance();

  Future<Either<Failure, List<Attendance>>> getAttendanceHistory(String date);
}
