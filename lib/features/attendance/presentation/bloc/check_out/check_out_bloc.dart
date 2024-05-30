import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/usecases/check_out.dart';

part 'check_out_event.dart';
part 'check_out_state.dart';

class CheckOutBloc extends Bloc<CheckOutEvent, CheckOutState> {
  final CheckOut checkOut;

  CheckOutBloc({required this.checkOut}) : super(CheckOutInitial()) {
    on<CheckOutEvent>((event, emit) async {
      emit(CheckOutLoading());

      final result = await checkOut.call(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      result.fold(
        (l) => emit(
          CheckOutError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) => emit(CheckOutSuccess(result: r)),
      );
    });
  }
}
