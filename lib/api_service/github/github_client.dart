import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_search_result.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_search_result_error.dart';

///
/// API Service that searches GitHub for repositories.
///
class GithubClient {
  GithubClient({
    http.Client? httpClient,
    this.baseUrl = "https://api.github.com/search/repositories?q=",
  }) : this.httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client httpClient;

  ///
  /// Searches for repositories based on the provided [term].
  ///
  /// Throws [GithubSearchResultError] for HTTP response codes other than
  /// `200`.
  ///
  Future<GithubSearchResult> search(String term) async {
    final response = await httpClient.get(Uri.parse("$baseUrl$term"));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return GithubSearchResult.fromJson(results);
    } else {
      throw GithubSearchResultError.fromJson(results);
    }
  }
}
