import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ProfileLocalDatasource {
  Future<UserModel> getUserProfile();
}

class ProfileLocalDatasourceImpl extends ProfileLocalDatasource {
  final AuthLocalDatasource authLocalDatasource;

  ProfileLocalDatasourceImpl({required this.authLocalDatasource});

  @override
  Future<UserModel> getUserProfile() async {
    final user = await authLocalDatasource.getUser();
    if (user != null) {
      return user;
    }
    return UserModel.initial();
  }
}
