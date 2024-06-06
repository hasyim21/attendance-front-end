import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/usecases/add_permission.dart';

part 'add_permission_event.dart';
part 'add_permission_state.dart';

class AddPermissionBloc extends Bloc<AddPermissionEvent, AddPermissionState> {
  final AddPermission _addPermission;

  AddPermissionBloc(this._addPermission) : super(AddPermissionInitial()) {
    on<AddPermissionEvent>((event, emit) async {
      emit(AddPermissionLoading());
      final result = await _addPermission.call(
        image: event.image,
        date: event.date,
        reason: event.reason,
      );

      result.fold(
        (l) => emit(
          AddPermissionError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) => emit(AddPermissionSuccess(result: r)),
      );
    });
  }
}
