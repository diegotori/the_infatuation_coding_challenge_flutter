part of 'saved_repos_bloc.dart';

///
/// Represents our state of Saved Repositories from our backend.
///
/// Use this in your UI for rendering the current state to the user.
///
class SavedReposState extends Equatable {
  @visibleForTesting
  const SavedReposState(
      {required this.stateType,
      this.errorMsg = "",
      this.errorCode = SavedReposErrorCode.none,
      this.sortByStars = false,
      this.results = const [],
      this.currentResults = const [],
      GithubRepo? repoToCreate,
      String? repoId})
      : this.repoToCreate = repoToCreate,
        this.repoId = repoId;

  ///
  /// This instance's [SavedReposStateType].
  ///
  final SavedReposStateType stateType;

  ///
  /// This instance's error message.
  ///
  final String errorMsg;

  ///
  /// This instance's [SavedReposErrorCode].
  ///
  final SavedReposErrorCode errorCode;

  ///
  /// Whether Saved Repos are to be sorted by stargazer count.
  ///
  final bool sortByStars;

  ///
  /// This instance's original [List] of [SavedRepo]s.
  ///
  final List<SavedRepo> results;

  ///
  /// This instance's current [List] of [SavedRepo]s. This is typically sorted
  /// based on the current value of [sortByStars].
  ///
  final List<SavedRepo> currentResults;

  ///
  /// This instance's [GithubRepo] to create when it fails to create a repo,
  /// which enables the user to retry saving it. Otherwise, `null`.
  ///
  final GithubRepo? repoToCreate;

  ///
  /// This instance's Repo ID to delete when it fails to delete a repo,
  /// which enables the user to retry. Otherwise, `null`.
  ///
  final String? repoId;

  ///
  /// Our initial state.
  ///
  factory SavedReposState.initial() =>
      SavedReposState(stateType: SavedReposStateType.initial);

  ///
  /// Creates a new instance, while optionally defining new properties for
  /// the resulting instance.
  ///
  SavedReposState update(
      {SavedReposStateType? stateType,
      String? errorMsg,
      SavedReposErrorCode? errorCode,
      bool? sortByStars,
      List<SavedRepo>? results,
      List<SavedRepo>? currentResults,
      GithubRepo? repoToCreate,
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

///
/// Represents our various state types, such as loading,
/// displaying our saved repos, or error/no-data states.
///
enum SavedReposStateType {
  ///
  /// Our initial state type.
  ///
  initial,

  ///
  /// Indicates that we are currently loading our saved repos.
  ///
  loading,

  ///
  /// Indicates that we are currently display our saved repos.
  ///
  display_saved_repos,

  ///
  /// Indicates that an error occurred when loading our saved repos.
  ///
  error,

  ///
  /// Indicates that there were no saved repos found.
  ///
  no_saved_repos,

  ///
  /// Indicates that we are currently pulling to refresh our saved repos.
  ///
  pull_to_refresh
}

///
/// Represents a contextual error code, indicating a reason as to why
/// a particular error occurred.
///
enum SavedReposErrorCode {
  ///
  /// No error.
  ///
  none,

  ///
  /// Indicates that the error occurred while fetching saved repos.
  ///
  fetch_repo_error,

  ///
  /// Indicates that the error occurred when creating a saved repo.
  ///
  create_repo_error,

  ///
  /// Indicates that the error occurred when deleting a saved repo.
  ///
  delete_repo_error,
}
