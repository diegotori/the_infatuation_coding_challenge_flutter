part of 'saved_repos_bloc.dart';

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

  factory SavedReposEvent.fetchSavedRepos(
      {bool? forceRefresh, bool? pullToRefresh}) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.fetch_saved_repos,
        forceRefresh: forceRefresh,
        pullToRefresh: pullToRefresh);
  }

  factory SavedReposEvent.createRepo(GithubRepo repoToCreate) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.create_repo, repoToCreate: repoToCreate);
  }

  factory SavedReposEvent.deleteRepo(String repoId) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.delete_repo, repoId: repoId);
  }

  factory SavedReposEvent.clearErrorCode() {
    return SavedReposEvent._(eventType: SavedReposEventType.clear_error_code);
  }

  factory SavedReposEvent.toggleSortByStars() {
    return SavedReposEvent._(
        eventType: SavedReposEventType.toggle_sort_by_stars);
  }

  @override
  List<Object?> get props =>
      [eventType, repoToCreate, forceRefresh, pullToRefresh, repoId];
}

enum SavedReposEventType {
  fetch_saved_repos,
  create_repo,
  delete_repo,
  clear_error_code,
  toggle_sort_by_stars
}
