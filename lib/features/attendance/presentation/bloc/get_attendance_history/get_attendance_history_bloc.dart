import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/usecases/get_attendance_history.dart';

part 'get_attendance_history_event.dart';
part 'get_attendance_history_state.dart';

class GetAttendanceHistoryBloc
    extends Bloc<GetAttendanceHistoryEvent, GetAttendanceHistoryState> {
  final GetAttendanceHistory getAttendanceHistory;

  GetAttendanceHistoryBloc({required this.getAttendanceHistory})
      : super(GetAttendanceHistoryInitial()) {
    on<GetAttendanceHistoryEvent>((event, emit) async {
      emit(GetAttendanceHistoryLoading());

      final result = await getAttendanceHistory.call(
          startDate: event.startDate, endDate: event.endDate);

      result.fold(
        (l) => emit(
          GetAttendanceHistoryError(
            failure: Failure(message: l.message),
          ),
        ),
        (r) => emit(GetAttendanceHistorySuccess(result: r)),
      );
    });
  }
}
