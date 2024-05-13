import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../domain/usecases/logout.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final Logout logout;
  final AuthLocalDatasource authLocalDatasource;

  LogoutBloc({required this.logout, required this.authLocalDatasource})
      : super(LogoutInitial()) {
    on<LogoutEvent>((event, emit) async {
      emit(LogoutLoading());

      final result = await logout.call();

      result.fold(
        (l) => emit(
          LogoutError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) async {
          emit(LogoutSuccess(result: r));
          await authLocalDatasource.deleteToken();
        },
      );
    });
  }
}
