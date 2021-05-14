part of 'saved_repos_bloc.dart';

class SavedReposEvent extends Equatable {
  final SavedReposEventType eventType;
  final GithubRepo? repoToCreate;
  final int? repoId;
  const SavedReposEvent._(
      {required this.eventType, this.repoToCreate, this.repoId});

  factory SavedReposEvent.fetchSavedRepos() {
    return SavedReposEvent._(eventType: SavedReposEventType.fetch_saved_repos);
  }

  factory SavedReposEvent.createRepo(GithubRepo repoToCreate) {
    return SavedReposEvent._(
        eventType: SavedReposEventType.create_repo, repoToCreate: repoToCreate);
  }

  factory SavedReposEvent.deleteRepo(int repoId) {
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
  List<Object?> get props => [eventType, repoToCreate, repoId];
}

enum SavedReposEventType {
  fetch_saved_repos,
  create_repo,
  delete_repo,
  clear_error_code,
  toggle_sort_by_stars
}
