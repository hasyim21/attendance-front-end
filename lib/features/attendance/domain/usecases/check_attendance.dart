import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/attendance_status.dart';
import '../repositories/attendance_repository.dart';

class CheckAttendance {
  final AttendanceRepository attendanceRepository;

  CheckAttendance({required this.attendanceRepository});

  Future<Either<Failure, AttendanceStatus>> call() async {
    return await attendanceRepository.checkAttendance();
  }
}
