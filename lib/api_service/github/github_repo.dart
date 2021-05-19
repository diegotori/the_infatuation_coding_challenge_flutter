import 'package:equatable/equatable.dart';

///
/// Represents a GitHub repository.
///
class GithubRepo extends Equatable {
  const GithubRepo(
      {required this.id,
      required this.fullName,
      required this.desc,
      required this.stargazersCount,
      required this.language,
      required this.url,
      required this.createdAt});

  ///
  /// This repository's identifier.
  ///
  final int id;

  ///
  /// This repository's Full Name.
  ///
  final String fullName;

  ///
  /// This repository's Description.
  ///
  final String desc;

  ///
  /// This repository's Stargazer Count.
  ///
  final int stargazersCount;

  ///
  /// This repository's Programming Language.
  ///
  final String language;

  ///
  /// This repository's URL.
  ///
  final String url;

  ///
  /// This repository's Creation Date as an ISO-8601 timestamp value.
  ///
  final String createdAt;

  ///
  /// Creates a new instance from a raw parsed JSON [Map].
  ///
  static GithubRepo fromJson(dynamic json) {
    return GithubRepo(
        id: json['id'] as int,
        fullName: json['full_name'] as String,
        desc: json['description'] != null ? json['description'] as String : "",
        stargazersCount: json['stargazers_count'] as int,
        language: json['language'] != null ? json['language'] as String : "",
        url: json['html_url'] as String,
        createdAt: json['created_at'] as String);
  }

  @override
  List<Object?> get props =>
      [id, fullName, desc, stargazersCount, language, url, createdAt];

  @override
  String toString() {
    return 'GithubRepo{id: $id, fullName: $fullName, desc: $desc, '
        'stargazersCount: $stargazersCount, language: $language, '
        'url: $url, createdAt: $createdAt}';
  }
}

extension GithubRepoExtension on GithubRepo {
  /// Returns [createdAt] as a [DateTime].
  DateTime get createdAtDate => DateTime.parse(createdAt);
}
