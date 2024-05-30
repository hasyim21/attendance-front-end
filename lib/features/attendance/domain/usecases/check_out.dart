import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class CheckOut {
  final AttendanceRepository attendanceRepository;

  CheckOut({required this.attendanceRepository});

  Future<Either<Failure, Attendance>> call({
    required String latitude,
    required String longitude,
  }) async {
    return await attendanceRepository.checkOut(latitude, longitude);
  }
}
