import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../domain/entities/auth.dart';
import '../../../domain/usecases/login.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;
  final AuthLocalDatasource authLocalDatasource;

  LoginBloc({required this.login, required this.authLocalDatasource})
      : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());

      final result = await login.call(
        email: event.email,
        password: event.password,
      );

      result.fold(
        (l) => emit(
          LoginError(
            failure: Failure(
              message: l.message,
            ),
          ),
        ),
        (r) async {
          emit(LoginSuccess(result: r));
          await authLocalDatasource.setToken(r.token);
        },
      );
    });
  }
}
