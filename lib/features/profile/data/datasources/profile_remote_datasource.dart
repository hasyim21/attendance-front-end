import 'dart:convert';

import '../../../../core/core.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDatasource {
  Future<UserModel> getUserProfile();
}

class ProfileRemoteDatasourceImpl extends ProfileRemoteDatasource {
  final http.Client client;
  final AuthLocalDatasource authLocalDatasource;

  ProfileRemoteDatasourceImpl({
    required this.client,
    required this.authLocalDatasource,
  });

  @override
  Future<UserModel> getUserProfile() async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/profile');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['user'];
      return UserModel.fromMap(data);
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }
}
