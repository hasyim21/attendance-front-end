import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../entities/company.dart';
import '../repositories/attendance_repository.dart';

class GetCompany {
  final AttendanceRepository attendanceRepository;

  GetCompany({required this.attendanceRepository});

  Future<Either<Failure, Company>> call() async {
    return await attendanceRepository.getCompany();
  }
}
