import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/models/user_model.dart';
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
          final user = r.user;
          final userModel = UserModel(
            id: user.id,
            name: user.name,
            email: user.email,
            phone: user.phone,
            role: user.role,
            position: user.position,
            department: user.department,
            faceEmbedding: user.faceEmbedding,
            imageUrl: user.imageUrl,
          );
          await authLocalDatasource.setToken(r.token);
          await authLocalDatasource.setUser(userModel);
        },
      );
    });
  }
}
