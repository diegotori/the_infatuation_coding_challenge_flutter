import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:the_infatuation_coding_challenge_flutter/api_service/saved_repo.dart';

///
/// {@template reposerver_api_service}
/// API Service that fetches, creates and deletes Saved Repositories
/// from the backend.
/// {@endtemplate}
///
class RepoServerApiService {
  final http.Client _httpClient;
  final String _baseUrl;

  /// {@macro reposerver_api_service}
  RepoServerApiService(
      {http.Client? httpClient, String? baseUrl, bool isAndroidSim = false})
      : this._httpClient = httpClient ?? http.Client(),
        this._baseUrl = baseUrl ??
            "http://${isAndroidSim ? "10.0.2.2" : "localhost"}:8080/repo/";

  ///
  /// Fetches a [List] of [SavedRepo]s from the `reposerver` backend.
  ///
  /// Throws [RepoServerApiException] for all HTTP Status Codes aside from
  /// `200`.
  ///
  Future<List<SavedRepo>> get savedRepos async {
    List<SavedRepo> result = [];
    final resp = await _httpClient.get(Uri.parse(_baseUrl));
    final decoded = jsonDecode(resp.body);
    final statusCode = resp.statusCode;
    if (statusCode == 200) {
      result = (decoded['repos'] as List)
          .map<SavedRepo>((e) => SavedRepo.fromJsonMap(e)!)
          .toList();
    } else {
      throw RepoServerApiException(statusCode, "Failed to fetch saved repos.",
          rawMessage: decoded);
    }
    return result;
  }

  ///
  /// Creates a new repository with the provided [repoToSave].
  ///
  /// Throws [RepoServerApiException] for all HTTP Status Codes aside from
  /// `200`.
  ///
  Future<SavedRepo> createRepo(SavedRepo repoToSave) async {
    final jsonBody = repoToSave.toJson();
    final resp = await _httpClient.post(Uri.parse(_baseUrl), body: jsonBody);
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

  ///
  /// Deletes a new repository with the provided [repoId].
  ///
  /// Throws [RepoServerApiException] for all HTTP Status Codes aside from
  /// `200`.
  ///
  Future<String> deleteRepo(String repoId) async {
    final resp = await _httpClient.delete(Uri.parse("$_baseUrl$repoId"));
    final statusCode = resp.statusCode;
    if (statusCode != 200) {
      throw RepoServerApiException(
          statusCode, "Failed to delete repo ID $repoId.",
          rawMessage: resp.body);
    }
    return "";
  }
}

///
/// Represents an error returned when interacting with the `reposerver`
/// backend.
///
class RepoServerApiException implements Exception {
  /// This error's HTTP Status Code.
  final int statusCode;

  /// This error's message.
  final String message;

  /// This error's raw [Object] message, or `null` if unavailable.
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
