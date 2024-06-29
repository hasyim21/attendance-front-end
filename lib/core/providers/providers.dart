import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/usecases/check_attendance.dart';
import '../../features/attendance/domain/usecases/check_in.dart';
import '../../features/attendance/domain/usecases/check_out.dart';
import '../../features/attendance/domain/usecases/get_attendance_history.dart';
import '../../features/attendance/domain/usecases/get_company.dart';
import '../../features/attendance/domain/usecases/update_face_embedding.dart';
import '../../features/attendance/presentation/bloc/check_attendance/check_attendance_bloc.dart';
import '../../features/attendance/presentation/bloc/check_in/check_in_bloc.dart';
import '../../features/attendance/presentation/bloc/check_out/check_out_bloc.dart';
import '../../features/attendance/presentation/bloc/get_attendance_history/get_attendance_history_bloc.dart';
import '../../features/attendance/presentation/bloc/get_company/get_company_bloc.dart';
import '../../features/attendance/presentation/bloc/update_face_embedding/update_face_embedding_bloc.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/is_auth.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/bloc/login/login_bloc.dart';
import '../../features/auth/presentation/bloc/logout/logout_bloc.dart';
import '../../features/note/data/datasources/note_remote_datasource.dart';
import '../../features/note/data/repositories/note_repository_impl.dart';
import '../../features/note/domain/usecases/add_note.dart';
import '../../features/note/domain/usecases/delete_note.dart';
import '../../features/note/domain/usecases/get_notes.dart';
import '../../features/note/domain/usecases/update_note.dart';
import '../../features/note/presentation/bloc/add_note/add_note_bloc.dart';
import '../../features/note/presentation/bloc/delete_note/delete_note_bloc.dart';
import '../../features/note/presentation/bloc/notes/notes_bloc.dart';
import '../../features/note/presentation/bloc/update_note/update_note_bloc.dart';
import '../../features/permission/data/datasources/permission_remote_datasource.dart';
import '../../features/permission/data/repositories/permission_repository_impl.dart';
import '../../features/permission/domain/usecases/add_permission.dart';
import '../../features/permission/domain/usecases/get_permissions.dart';
import '../../features/permission/presentation/bloc/add_permission/add_permission_bloc.dart';
import '../../features/permission/presentation/bloc/get_permissions/get_permissions_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/presentation/bloc/get_user_profile/get_user_profile_bloc.dart';

class Providers extends StatelessWidget {
  final http.Client client;
  final AuthLocalDatasource authLocalDatasource;
  final MaterialApp app;

  const Providers({
    super.key,
    required this.client,
    required this.authLocalDatasource,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepositoryImpl(
            authRemoteDatasource: AuthRemoteDatasourceImpl(
              client: client,
              authLocalDatasource: authLocalDatasource,
            ),
            authLocalDatasource: authLocalDatasource,
          ),
        ),
        RepositoryProvider(
          create: (context) => AttendanceRepositoryImpl(
            attendanceRemoteDatasource: AttendanceRemoteDatasourceImpl(
              client: client,
              authLocalDatasource: authLocalDatasource,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => PermissionRepositoryImpl(
            permissionRemoteDatasource: PermissionRemoteDatasourceImpl(
              client: client,
              authLocalDatasource: authLocalDatasource,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => NoteRepositoryImpl(
            noteRemoteDatasource: NoteRemoteDatasourceImpl(
              client: client,
              authLocalDatasource: authLocalDatasource,
            ),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepositoryImpl(
            profileRemoteDatasource: ProfileRemoteDatasourceImpl(
              client: client,
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
          BlocProvider(
            create: (context) => GetAttendanceHistoryBloc(
              getAttendanceHistory: GetAttendanceHistory(
                attendanceRepository: context.read<AttendanceRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AddPermissionBloc(
              AddPermission(
                permissionRepository: context.read<PermissionRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => GetPermissionsBloc(
              GetPermissions(
                context.read<PermissionRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => NotesBloc(
              GetNotes(
                context.read<NoteRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => AddNoteBloc(
              AddNote(
                noteRepository: context.read<NoteRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => UpdateNoteBloc(
              UpdateNote(
                context.read<NoteRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => DeleteNoteBloc(
              DeleteNote(
                context.read<NoteRepositoryImpl>(),
              ),
            ),
          ),
          BlocProvider(
            create: (context) => GetUserProfileBloc(
              GetUserProfile(
                profileRepository: context.read<ProfileRepositoryImpl>(),
              ),
            ),
          ),
        ],
        child: app,
      ),
    );
  }
}
