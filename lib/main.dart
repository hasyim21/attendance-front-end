import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  prefs = await SharedPreferences.getInstance();
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
        RepositoryProvider(
          create: (context) => AttendanceRepositoryImpl(
            attendanceRemoteDatasource: AttendanceRemoteDatasourceImpl(
              client: http.Client(),
              authLocalDatasource: authLocalDatasource,
            ),
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
          BlocProvider(
            create: (context) => UpdateFaceEmbeddingBloc(
              updateFaceEmbedding: UpdateFaceEmbedding(
                attendanceRepository: context.read<AttendanceRepositoryImpl>(),
              ),
              authLocalDatasource: authLocalDatasource,
            ),
          ),
          BlocProvider(
            create: (context) => GetCompanyBloc(
              getCompany: GetCompany(
                attendanceRepository: context.read<AttendanceRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CheckAttendanceBloc(
              checkAttendance: CheckAttendance(
                attendanceRepository: context.read<AttendanceRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CheckInBloc(
              checkIn: CheckIn(
                attendanceRepository: context.read<AttendanceRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => CheckOutBloc(
              checkOut: CheckOut(
                attendanceRepository: context.read<AttendanceRepositoryImpl>(),
              ),
            ),
          ),
        ],
        child: const App(),
      ),
    );
  }
}
