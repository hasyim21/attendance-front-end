import 'package:attendance_front_end/features/attendance/domain/entities/company.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure/failure.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/entities/attendance_status.dart';
import '../../domain/entities/face_embedding.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceRemoteDatasource attendanceRemoteDatasource;

  AttendanceRepositoryImpl({required this.attendanceRemoteDatasource});

  @override
  Future<Either<Failure, FaceEmbedding>> updateFaceEmbedding(
    String faceEmbedding,
  ) async {
    try {
      final result =
          await attendanceRemoteDatasource.updateFaceEmbedding(faceEmbedding);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Company>> getCompany() async {
    try {
      final result = await attendanceRemoteDatasource.getCompany();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Attendance>> checkIn(
    String latitude,
    String longitude,
  ) async {
    try {
      final result =
          await attendanceRemoteDatasource.checkIn(latitude, longitude);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Attendance>> checkOut(
    String latitude,
    String longitude,
  ) async {
    try {
      final result =
          await attendanceRemoteDatasource.checkOut(latitude, longitude);
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceStatus>> checkAttendance() async {
    try {
      final result = await attendanceRemoteDatasource.checkAttendance();
      return Right(result);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
