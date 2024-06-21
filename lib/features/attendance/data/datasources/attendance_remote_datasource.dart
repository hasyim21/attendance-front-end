import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/attendance_model.dart';
import '../models/attendance_status_model.dart';
import '../models/company_model.dart';
import '../models/face_embedding_model.dart';

abstract class AttendanceRemoteDatasource {
  Future<FaceEmbeddingModel> updateFaceEmbedding(String faceEmbedding);
  Future<CompanyModel> getCompany();
  Future<AttendanceModel> checkIn(String latitude, String longitude);
  Future<AttendanceModel> checkOut(String latitude, String longitude);
  Future<AttendanceStatusModel> checkAttendance();
  Future<List<AttendanceModel>> getAttendanceHistory(
    String startDate,
    String endDate,
  );
}

class AttendanceRemoteDatasourceImpl extends AttendanceRemoteDatasource {
  final http.Client client;
  final AuthLocalDatasource authLocalDatasource;

  AttendanceRemoteDatasourceImpl(
      {required this.client, required this.authLocalDatasource});

  @override
  Future<FaceEmbeddingModel> updateFaceEmbedding(String faceEmbedding) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/update-face-embedding');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.post(
      url,
      headers: headers,
      body: json.encode({
        'face_embedding': faceEmbedding,
      }),
    );

    if (response.statusCode == 200) {
      return FaceEmbeddingModel.fromJson(response.body);
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<CompanyModel> getCompany() async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/company');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return CompanyModel.fromJson(response.body);
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<AttendanceModel> checkIn(String latitude, String longitude) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/checkin');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.post(
      url,
      headers: headers,
      body: json.encode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      return AttendanceModel.fromJson(response.body);
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<AttendanceModel> checkOut(String latitude, String longitude) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/checkout');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.post(
      url,
      headers: headers,
      body: json.encode({
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    if (response.statusCode == 200) {
      return AttendanceModel.fromJson(response.body);
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<AttendanceStatusModel> checkAttendance() async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/is-checkin');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return AttendanceStatusModel.fromJson(response.body);
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory(
    String startDate,
    String endDate,
  ) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse(
        '$mainUrl/attendance-history?start_date=$startDate&end_date=$endDate');
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
      final data = body['data'] as List;
      final histories =
          data.map((e) => AttendanceModel.fromDataMap(e)).toList();
      return histories;
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }
}
