import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<void> setToken(String token);
  Future<String?> getToken();
  Future<bool> deleteToken();
  Future<bool> isAuth();
  Future<void> setUser(UserModel userModel);
  Future<bool> deleteUser();
  Future<UserModel?> getUser();
  Future<void> updateFaceEmbedding(String faceEmbedding);
}

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  final SharedPreferences prefs;

  AuthLocalDatasourceImpl({required this.prefs});

  @override
  Future<void> setToken(String token) async {
    await prefs.setString('token', token);
  }

  @override
  Future<String?> getToken() async {
    final token = prefs.getString('token');
    if (token != null) {
      return token;
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteToken() async {
    return await prefs.remove('token');
  }

  @override
  Future<void> setUser(UserModel userModel) async {
    await prefs.setString('user', json.encode(userModel.toJson()));
  }

  @override
  Future<UserModel?> getUser() async {
    final user = prefs.getString('user');
    if (user != null) {
      return UserModel.fromJson(json.decode(user));
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteUser() async {
    return await prefs.remove('user');
  }

  @override
  Future<void> updateFaceEmbedding(String faceEmbedding) async {
    UserModel? user = await getUser();
    if (user != null) {
      user = user.copyWith(faceEmbedding: faceEmbedding);
      await setUser(user);
    }
  }

  @override
  Future<bool> isAuth() async {
    final token = await getToken();
    return token != null;
  }
}
