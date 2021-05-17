part of 'saved_repos_bloc.dart';

class SavedReposState extends Equatable {
  @visibleForTesting
  const SavedReposState(
      {required this.stateType,
      this.errorMsg = "",
      this.errorCode = SavedReposErrorCode.none,
      this.sortByStars = false,
      this.results = const [],
      this.currentResults = const [],
      SavedRepo? repoToCreate,
      String? repoId})
      : this.repoToCreate = repoToCreate,
        this.repoId = repoId;
  final SavedReposStateType stateType;
  final String errorMsg;
  final SavedReposErrorCode errorCode;
  final bool sortByStars;
  final List<SavedRepo> results;
  final List<SavedRepo> currentResults;
  final SavedRepo? repoToCreate;
  final String? repoId;

  factory SavedReposState.initial() =>
      SavedReposState(stateType: SavedReposStateType.initial);

  SavedReposState update(
      {SavedReposStateType? stateType,
      String? errorMsg,
      SavedReposErrorCode? errorCode,
      bool? sortByStars,
      List<SavedRepo>? results,
      List<SavedRepo>? currentResults,
      SavedRepo? repoToCreate,
      String? repoId}) {
    return SavedReposState(
        stateType: stateType ?? this.stateType,
        errorMsg: errorMsg ?? this.errorMsg,
        errorCode: errorCode ?? this.errorCode,
        sortByStars: sortByStars ?? this.sortByStars,
        results: results ?? this.results,
        currentResults: currentResults ?? this.currentResults,
        repoToCreate: repoToCreate,
        repoId: repoId);
  }

  @override
  List<Object?> get props => [
        stateType,
        errorMsg,
        errorCode,
        sortByStars,
        results,
        currentResults,
        repoToCreate,
        repoId
      ];

  @override
  String toString() {
    return 'SavedReposState{stateType: $stateType, errorMsg: $errorMsg, '
        'errorCode: $errorCode, sortByStars: $sortByStars, '
        'results: $results, currentResults: $currentResults}';
  }
}

enum SavedReposStateType {
  initial,
  loading,
  display_saved_repos,
  error,
  no_saved_repos,
  pull_to_refresh
}

enum SavedReposErrorCode {
  none,
  fetch_repo_error,
  create_repo_error,
  delete_repo_error,
}
