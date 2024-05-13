import 'package:attendance_front_end/features/auth/domain/usecases/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/profile_repository_impl.dart';
import 'features/auth/domain/usecases/is_auth.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/auth/presentation/bloc/login/login_bloc.dart';
import 'features/auth/presentation/bloc/logout/logout_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final authLocalDatasource = AuthLocalDatasourceImpl(prefs: prefs);
  runApp(
    MyApp(authLocalDatasource: authLocalDatasource),
  );
}

class MyApp extends StatelessWidget {
  final AuthLocalDatasource authLocalDatasource;

  const MyApp({super.key, required this.authLocalDatasource});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepositoryImpl(
            authRemoteDatasource: AuthRemoteDatasourceImpl(
              client: http.Client(),
              authLocalDatasource: authLocalDatasource,
            ),
            authLocalDatasource: authLocalDatasource,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              isAuth: IsAuth(
                authRepository: context.read<AuthRepositoryImpl>(),
              ),
            )..add(AuthStatus()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              login: Login(
                authRepository: context.read<AuthRepositoryImpl>(),
              ),
              authLocalDatasource: authLocalDatasource,
            ),
          ),
          BlocProvider(
            create: (context) => LogoutBloc(
              logout: Logout(
                authRepository: context.read<AuthRepositoryImpl>(),
              ),
              authLocalDatasource: authLocalDatasource,
            ),
          ),
        ],
        child: const App(),
      ),
    );
  }
}
