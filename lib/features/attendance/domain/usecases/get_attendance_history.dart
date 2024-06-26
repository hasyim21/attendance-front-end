import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceHistory {
  final AttendanceRepository attendanceRepository;

  GetAttendanceHistory({required this.attendanceRepository});

  Future<Either<Failure, List<Attendance>>> call({
    required String startDate,
    required String endDate,
  }) async {
    return await attendanceRepository.getAttendanceHistory(startDate, endDate);
  }
}
