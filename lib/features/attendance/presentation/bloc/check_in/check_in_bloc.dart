import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/usecases/check_in.dart';

part 'check_in_event.dart';
part 'check_in_state.dart';

class CheckInBloc extends Bloc<CheckInEvent, CheckInState> {
  final CheckIn checkIn;

  CheckInBloc({required this.checkIn}) : super(CheckInInitial()) {
    on<CheckInEvent>((event, emit) async {
      emit(CheckInLoading());

      final result = await checkIn.call(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      result.fold(
        (l) => emit(
          CheckInError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) => emit(CheckInSuccess(result: r)),
      );
    });
  }
}
