import 'package:equatable/equatable.dart';

class GithubRepo extends Equatable {
  const GithubRepo(
      {required this.id,
      required this.fullName,
      required this.desc,
      required this.stargazersCount,
      required this.language,
      required this.url,
      required this.createdAt});

  final int id;
  final String fullName;
  final String desc;
  final int stargazersCount;
  final String language;
  final String url;
  final String createdAt;

  static GithubRepo fromJson(dynamic json) {
    return GithubRepo(
        id: json['id'] as int,
        fullName: json['full_name'] as String,
        desc: json['description'] as String,
        stargazersCount: json['stargazers_count'] as int,
        language: json['language'] as String,
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
  DateTime get createdAtDate => DateTime.parse(createdAt);
}
