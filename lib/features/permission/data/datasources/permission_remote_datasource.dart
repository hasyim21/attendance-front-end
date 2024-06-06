import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/permission_model.dart';

abstract class PermissionRemoteDatasource {
  Future<String> addPermission(String image, String date, String reason);
  Future<List<PermissionModel>> getPermissions();
}

class PermissionRemoteDatasourceImpl extends PermissionRemoteDatasource {
  final http.Client client;
  final AuthLocalDatasource authLocalDatasource;

  PermissionRemoteDatasourceImpl(
      {required this.client, required this.authLocalDatasource});

  @override
  Future<String> addPermission(String image, String date, String reason) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/permission');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields.addAll({
      'date': date,
      'reason': reason,
    });
    request.files.add(await http.MultipartFile.fromPath('image', image));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return 'Permission added successfully';
    } else {
      throw Failure(message: 'Failed to add permission');
    }
  }

  @override
  Future<List<PermissionModel>> getPermissions() async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/permission');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final data = body['permissions'] as List;
      final notes = data.map((e) => PermissionModel.fromMap(e)).toList();
      return notes;
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }
}
