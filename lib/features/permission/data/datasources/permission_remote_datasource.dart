import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

abstract class PermissionRemoteDatasource {
  Future<String> addPermission(String image, String date, String reason);
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
}
