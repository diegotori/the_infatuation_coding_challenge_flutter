import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:the_infatuation_coding_challenge_flutter/api_service/saved_repo.dart';

class RepoServerApiService {
  final http.Client _httpClient;
  final String _baseUrl;

  RepoServerApiService({http.Client? httpClient, String? baseUrl})
      : this._httpClient = httpClient ?? http.Client(),
        this._baseUrl = baseUrl ?? "http://localhost:8080/repo/";

  Future<List<SavedRepo>> get savedRepos async {
    List<SavedRepo> result = [];
    final resp = await _httpClient.get(Uri.parse(_baseUrl));
    final decoded = jsonDecode(resp.body);
    final statusCode = resp.statusCode;
    if (statusCode == 200) {
      result = (decoded as List)
          .map<SavedRepo>((e) => SavedRepo.fromJsonMap(e)!)
          .toList();
    } else {
      throw RepoServerApiException(statusCode, "Failed to fetch saved repos.",
          rawMessage: decoded);
    }
    return result;
  }

  Future<SavedRepo> createRepo(SavedRepo repoToSave) async {
    final resp =
        await _httpClient.post(Uri.parse(_baseUrl), body: repoToSave.toJson());
    final decoded = jsonDecode(resp.body);
    final statusCode = resp.statusCode;
    if (statusCode == 200) {
      return SavedRepo.fromJsonMap(decoded)!;
    } else {
      throw RepoServerApiException(
          statusCode, "Failed to create repo $repoToSave.",
          rawMessage: decoded);
    }
  }

  Future<String> deleteRepo(int repoId) async {
    final resp = await _httpClient.delete(Uri.parse("$_baseUrl$repoId/"));
    final decoded = jsonDecode(resp.body);
    final statusCode = resp.statusCode;
    if (statusCode != 200 || statusCode != 204) {
      throw RepoServerApiException(
          statusCode, "Failed to delete repo ID $repoId.",
          rawMessage: decoded);
    }
    return "";
  }
}

class RepoServerApiException implements Exception {
  final int statusCode;
  final String message;
  final Object? rawMessage;

  RepoServerApiException(this.statusCode, this.message, {this.rawMessage});

  @override
  String toString() {
    return 'RepoServerApiException{statusCode: $statusCode, message: $message, '
        'rawMessage: $rawMessage}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepoServerApiException &&
          runtimeType == other.runtimeType &&
          statusCode == other.statusCode &&
          message == other.message;

  @override
  int get hashCode => statusCode.hashCode ^ message.hashCode;
}
