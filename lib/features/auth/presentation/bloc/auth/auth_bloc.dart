import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/is_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IsAuth isAuth;

  AuthBloc({required this.isAuth}) : super(Unauthenticated()) {
    on<AuthStatus>((event, emit) async {
      try {
        final result = await isAuth.call();
        result.fold(
          (l) => emit(Unauthenticated()),
          (r) {
            if (r) {
              emit(Authenticated());
            } else {
              emit(Unauthenticated());
            }
          },
        );
      } catch (_) {
        emit(Unauthenticated());
      }
    });
  }
}
