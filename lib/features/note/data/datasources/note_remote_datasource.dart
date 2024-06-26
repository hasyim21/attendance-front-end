import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/core.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/note_model.dart';

abstract class NoteRemoteDatasource {
  Future<List<NoteModel>> getNotes(int page, int perPage);
  Future<String> addNote(String title, String note);
  Future<String> updateNote(
    int id,
    String title,
    String note,
    bool isCompleted,
  );
  Future<String> deleteNote(int id);
}

class NoteRemoteDatasourceImpl extends NoteRemoteDatasource {
  final http.Client client;
  final AuthLocalDatasource authLocalDatasource;

  NoteRemoteDatasourceImpl(
      {required this.client, required this.authLocalDatasource});

  @override
  Future<List<NoteModel>> getNotes(int page, int perPage) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/api-notes?page=$page&per_page=$perPage');
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
      final notes = data.map((e) => NoteModel.fromMap(e)).toList();
      return notes;
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<String> addNote(String title, String note) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/api-notes');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.post(
      url,
      headers: headers,
      body: json.encode({
        'title': title,
        'note': note,
      }),
    );

    if (response.statusCode == 201) {
      return 'Note created successfully';
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<String> updateNote(
    int id,
    String title,
    String note,
    bool isCompleted,
  ) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/api-notes/$id');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.patch(
      url,
      headers: headers,
      body: json.encode({
        'title': title,
        'note': note,
        'is_completed': isCompleted,
      }),
    );

    if (response.statusCode == 200) {
      return 'Note updated successfully';
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }

  @override
  Future<String> deleteNote(int id) async {
    final token = await authLocalDatasource.getToken();
    final url = Uri.parse('$mainUrl/api-notes/$id');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await client.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return 'Note deleted successfully';
    } else {
      throw Failure(message: json.decode(response.body)['message']);
    }
  }
}
