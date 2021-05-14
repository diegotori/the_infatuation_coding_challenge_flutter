part of 'search_repos_bloc.dart';

class SearchReposState extends Equatable {
  final SearchReposStateType stateType;
  final String query;
  final List<GithubRepo> repos;
  final String errorMsg;

  @visibleForTesting
  SearchReposState(
      {required this.stateType,
      this.query = "",
      this.repos = const [],
      this.errorMsg = ""});

  factory SearchReposState.initial() =>
      SearchReposState(stateType: SearchReposStateType.initial);

  SearchReposState update(
      {SearchReposStateType? stateType,
      String? query,
      List<GithubRepo>? repos,
      String? errorMsg}) {
    return SearchReposState(
        stateType: stateType ?? this.stateType,
        query: query ?? this.query,
        repos: repos ?? this.repos,
        errorMsg: errorMsg ?? this.errorMsg);
  }

  @override
  List<Object?> get props => [stateType, repos, errorMsg];

  @override
  String toString() {
    return 'SearchReposState{stateType: $stateType, repos: $repos, '
        'errorMsg: $errorMsg}';
  }
}

enum SearchReposStateType {
  initial,
  loading,
  results,
  no_results,
  empty_text,
  error
}
