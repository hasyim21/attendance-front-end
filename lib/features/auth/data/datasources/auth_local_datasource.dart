import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_model.dart';

abstract class AuthLocalDatasource {
  Future<void> setToken(String token);
  Future<String> getToken();
  Future<bool> deleteToken();
  Future<bool> isAuth();
  Future<void> setUser(AuthModel user);
  Future<AuthModel> getUser();
}

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final SharedPreferences prefs;

  AuthLocalDatasourceImpl({required this.prefs});

  @override
  Future<void> setToken(String token) async {
    await prefs.setString('token', token);
  }

  @override
  Future<String> getToken() async {
    return prefs.getString('token') ?? '';
  }

  @override
  Future<bool> deleteToken() async {
    return await prefs.remove('token');
  }

  @override
  Future<void> setUser(AuthModel user) async {
    await prefs.setString('user', json.encode(user.toJson()));
  }

  @override
  Future<AuthModel> getUser() async {
    final userString = prefs.getString('user');
    if (userString != null && userString.isNotEmpty) {
      return AuthModel.fromJson(json.decode(userString));
    } else {
      return AuthModel.initial();
    }
  }

  @override
  Future<bool> isAuth() async {
    final token = await getToken();
    return token.isNotEmpty;
  }
}
