import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../domain/entities/permission.dart';
import '../../../domain/usecases/get_permissions.dart';

part 'get_permissions_event.dart';
part 'get_permissions_state.dart';

class GetPermissionsBloc
    extends Bloc<GetPermissionsEvent, GetPermissionsState> {
  final GetPermissions _getPermissions;

  GetPermissionsBloc(this._getPermissions) : super(GetPermissionsInitial()) {
    on<GetPermissionsEvent>((event, emit) async {
      emit(GetPermissionsLoading());

      final result = await _getPermissions.call(event.isApproved);

      result.fold(
        (l) => emit(
          GetPermissionsError(
            failure: Failure(message: l.message),
          ),
        ),
        (r) => emit(GetPermissionsSuccess(result: r)),
      );
    });
  }
}
