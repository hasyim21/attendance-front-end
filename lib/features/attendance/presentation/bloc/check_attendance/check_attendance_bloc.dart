import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/attendance_status.dart';
import '../../../domain/usecases/check_attendance.dart';

part 'check_attendance_event.dart';
part 'check_attendance_state.dart';

class CheckAttendanceBloc
    extends Bloc<CheckAttendanceEvent, CheckAttendanceState> {
  final CheckAttendance checkAttendance;

  CheckAttendanceBloc({required this.checkAttendance})
      : super(CheckAttendanceInitial()) {
    on<CheckAttendanceEvent>((event, emit) async {
      emit(CheckAttendanceLoading());

      final result = await checkAttendance.call();

      result.fold(
        (l) => emit(
          CheckAttendanceError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) => emit(CheckAttendanceSuccess(result: r)),
      );
    });
  }
}
