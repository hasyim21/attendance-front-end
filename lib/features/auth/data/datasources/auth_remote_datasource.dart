import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../models/auth_model.dart';
import 'auth_local_datasource.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> login(String email, String password);
  Future<String> logout();
}

class AuthRemoteDatasourceImpl extends AuthRemoteDatasource {
  final http.Client client;
  final AuthLocalDatasource authLocalDatasource;

  AuthRemoteDatasourceImpl({
    required this.client,
    required this.authLocalDatasource,
  });

  @override
  Future<AuthModel> login(String email, String password) async {
    final url = Uri.parse('$mainUrl/login');
    final headers = {'Content-Type': 'application/json'};

    final response = await client.post(
      url,
      headers: headers,
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return AuthModel.fromJson(response.body);
    } else {
      throw Failure(message: 'Invalid credentials');
    }
  }

  @override
  Future<String> logout() async {
    final token = await authLocalDatasource.getToken();

    final url = Uri.parse('$mainUrl/logout');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.post(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw Failure(message: 'Failed to logout');
    }
  }
}
