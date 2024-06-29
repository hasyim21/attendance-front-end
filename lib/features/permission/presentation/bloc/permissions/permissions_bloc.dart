import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/permission.dart';
import '../../../domain/usecases/get_permissions.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final GetPermissions _getPermissions;

  PermissionsBloc(this._getPermissions) : super(PermissionsState.initial()) {
    on<GetPermissionsEvent>(_onGetPermissionsEvent);
    on<RefreshPermissionsEvent>(_onRefreshPermissionsEvent);
  }

  Future<void> _onGetPermissionsEvent(
      GetPermissionsEvent event, Emitter<PermissionsState> emit) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PermissionsStatus.initial) {
        final permissions = await _getPermissions.call(
          isApproved: event.isApproved,
          page: state.page,
          perPage: state.perPage,
        );
        permissions.fold(
          (failure) => emit(
            state.copyWith(
              status: PermissionsStatus.failure,
              message: failure.message,
            ),
          ),
          (permissions) => emit(
            state.copyWith(
              status: PermissionsStatus.success,
              permissions: permissions,
              page: state.page + 1,
              hasReachedMax: permissions.isEmpty,
            ),
          ),
        );
      } else {
        final permissions = await _getPermissions.call(
          isApproved: event.isApproved,
          page: state.page,
          perPage: state.perPage,
        );
        permissions.fold(
          (failure) => emit(
            state.copyWith(
              status: PermissionsStatus.failure,
              message: failure.message,
            ),
          ),
          (permissions) => emit(
            state.copyWith(
              status: PermissionsStatus.success,
              permissions: List.of(state.permissions)..addAll(permissions),
              page: state.page + 1,
              hasReachedMax: permissions.isEmpty,
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PermissionsStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshPermissionsEvent(
      RefreshPermissionsEvent event, Emitter<PermissionsState> emit) async {
    emit(PermissionsState.initial());
    await _onGetPermissionsEvent(
        GetPermissionsEvent(isApproved: event.isApproved), emit);
  }
}
