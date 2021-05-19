import 'package:equatable/equatable.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_repo.dart';

///
/// Represents our repository search results from GitHub.
///
class GithubSearchResult extends Equatable {
  const GithubSearchResult({required this.items});

  ///
  /// This instance's [List] or [GithubRepo]s.
  ///
  final List<GithubRepo> items;

  ///
  /// Creates a new instance from the provided raw [json] [Map].
  ///
  static GithubSearchResult fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>)
        .map(
            (dynamic item) => GithubRepo.fromJson(item as Map<String, dynamic>))
        .toList();
    return GithubSearchResult(items: items);
  }

  @override
  List<Object?> get props => [items];

  @override
  String toString() {
    return 'GithubSearchResult{items: $items}';
  }
}
