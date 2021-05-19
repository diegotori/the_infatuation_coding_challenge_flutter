part of 'saved_repos_bloc.dart';

///
/// Represents the possible actions one can perform when interacting with
/// the [SavedReposBloc].
///
class SavedReposEvent extends Equatable {
  final SavedReposEventType eventType;
  final GithubRepo? repoToCreate;
  final bool? forceRefresh;
  final bool? pullToRefresh;
  final String? repoId;
  const SavedReposEvent._(
      {required this.eventType,
      this.repoToCreate,
      this.repoId,
      this.forceRefresh,
      this.pullToRefresh});

  ///
  /// Fetch the current Saved Repos, while optionally [forceRefresh]ing or
  /// [pullToRefresh]ing the currently displayed Saved Repos.
  ///
  factory SavedReposEvent.fetchSavedRepos(
      {bool? forceRefresh, bool? pullToRefresh}) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.fetch_saved_repos,
        forceRefresh: forceRefresh,
        pullToRefresh: pullToRefresh);
  }

  ///
  /// Creates a new Saved Repo based on the provided [repoToCreate]
  ///
  factory SavedReposEvent.createRepo(GithubRepo repoToCreate) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.create_repo, repoToCreate: repoToCreate);
  }

  ///
  /// Deletes a Saved Repo based on the provided [repoId].
  ///
  factory SavedReposEvent.deleteRepo(String repoId) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.delete_repo, repoId: repoId);
  }

  ///
  /// Clears the current [SavedReposState]'s error code.
  ///
  factory SavedReposEvent.clearErrorCode() {
    return SavedReposEvent._(eventType: SavedReposEventType.clear_error_code);
  }

  ///
  /// Toggles whether or not to sort the Saved Repos by stargazer count.
  ///
  factory SavedReposEvent.toggleSortByStars() {
    return SavedReposEvent._(
        eventType: SavedReposEventType.toggle_sort_by_stars);
  }

  @override
  List<Object?> get props =>
      [eventType, repoToCreate, forceRefresh, pullToRefresh, repoId];
}

///
/// Represents the possible event types that [SavedReposBloc] can process.
///
enum SavedReposEventType {
  ///
  /// When attempting to fetch Saved Repos.
  ///
  fetch_saved_repos,

  ///
  /// When attempting to create a Saved Repo.
  ///
  create_repo,

  ///
  /// When attempting to delete a Saved Repo.
  ///
  delete_repo,

  ///
  /// When attempting to clear the current [SavedReposState]'s error code.
  ///
  clear_error_code,

  ///
  /// When attempting to toggle whether or not to sort the Saved Repos
  /// by stargazer count.
  ///
  toggle_sort_by_stars
}
