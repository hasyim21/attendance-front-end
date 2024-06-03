import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/usecases/add_permission.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final AddPermission addPermission;

  PermissionBloc({required this.addPermission}) : super(PermissionInitial()) {
    on<AddPermissionEvent>((event, emit) async {
      emit(PermissionLoading());
      final result = await addPermission.call(
        image: event.image,
        date: event.date,
        reason: event.reason,
      );

      result.fold(
        (l) => emit(
          PermissionError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) => emit(PermissionSuccess(result: r)),
      );
    });
  }
}
