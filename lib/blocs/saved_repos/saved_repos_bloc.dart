import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:meta/meta.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_repo.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/reposerver_api_service.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/saved_repo.dart';

part 'saved_repos_event.dart';
part 'saved_repos_state.dart';

class SavedReposBloc extends Bloc<SavedReposEvent, SavedReposState> {
  SavedReposBloc(this._repoServerApiService) : super(SavedReposState.initial());
  final RepoServerApiService _repoServerApiService;
  final _logger = FimberLog("SavedReposBloc");

  @override
  void onTransition(Transition<SavedReposEvent, SavedReposState> transition) {
    super.onTransition(transition);
    _logger
        .d("Transitioning states (Current State): ${transition.currentState}");
    _logger.d("Transitioning states (Event): ${transition.event}");
    _logger.d("Transitioning states (Next State): ${transition.nextState}");
  }

  @override
  Stream<SavedReposState> mapEventToState(
    SavedReposEvent event,
  ) async* {
    switch (event.eventType) {
      case SavedReposEventType.fetch_saved_repos:
        yield* _fetchSavedRepos(
            forceRefresh: event.forceRefresh ?? false,
            pullToRefresh: event.pullToRefresh ?? false);
        break;
      case SavedReposEventType.create_repo:
        final repoToCreate = event.repoToCreate!;
        final hasTenRepos = state.results.length == 10;
        if (hasTenRepos) {
          _logger.w("Cannot add more than 10 Saved Repos.");
          return;
        }
        yield* _createRepo(repoToCreate);
        break;
      case SavedReposEventType.delete_repo:
        final repoId = event.repoId!;
        yield* _deleteRepo(repoId);
        break;
      case SavedReposEventType.clear_error_code:
        yield state.update(errorCode: SavedReposErrorCode.none);
        break;
      case SavedReposEventType.toggle_sort_by_stars:
        final updatedValue = !state.sortByStars;
        final sortedResults = [...state.results];
        if (updatedValue) {
          // We now have to sort by stars.
          sortedResults.sortByStars();
        }
        yield state.update(
            sortByStars: updatedValue, currentResults: sortedResults);
        break;
    }
  }

  Stream<SavedReposState> _fetchSavedRepos(
      {bool forceRefresh = false, bool pullToRefresh = false}) async* {
    if ((state.stateType == SavedReposStateType.loading ||
            state.stateType == SavedReposStateType.error ||
            state.stateType == SavedReposStateType.display_saved_repos) &&
        !forceRefresh) {
      if (state.stateType == SavedReposStateType.loading) {
        _logger.i("Currently fetching Saved Repos.");
      } else if (state.stateType == SavedReposStateType.error) {
        _logger.i("Please force-refresh to try fetching Saved Repos.");
      } else if (state.stateType == SavedReposStateType.display_saved_repos) {
        _logger.i("We have already fetched Saved Repos.");
      }
      return;
    }
    if (pullToRefresh &&
        state.stateType == SavedReposStateType.pull_to_refresh) {
      _logger.i("Currently pulling to refresh our Saved Repos.");
      return;
    }

    if (forceRefresh) {
      _logger.i("Force-refreshing our Player's Saved Repos.");
    }

    var currentState = state;
    final bool wasDisplayingSavedRepos =
        currentState.stateType == SavedReposStateType.display_saved_repos;
    SavedReposStateType? previousStateType;
    if (pullToRefresh && wasDisplayingSavedRepos) {
      previousStateType = currentState.stateType;
      currentState = currentState.update(
          stateType: SavedReposStateType.pull_to_refresh,
          errorCode: SavedReposErrorCode.none);
    } else {
      currentState = currentState.update(
          stateType: SavedReposStateType.loading,
          errorCode: SavedReposErrorCode.none);
    }
    yield currentState;
    try {
      final savedRepos = await _repoServerApiService.savedRepos;
      if (savedRepos.isEmpty) {
        yield currentState.update(
            stateType: SavedReposStateType.no_saved_repos);
      } else {
        var sortedRepos = savedRepos;
        if (currentState.sortByStars) {
          sortedRepos.sortByStars();
        }
        yield currentState.update(
            stateType: SavedReposStateType.display_saved_repos,
            results: savedRepos,
            currentResults: sortedRepos);
      }
    } catch (e) {
      if (pullToRefresh && wasDisplayingSavedRepos) {
        yield currentState.update(stateType: previousStateType);
      } else {
        yield currentState.update(
            stateType: SavedReposStateType.error,
            errorMsg: e.toString(),
            errorCode: SavedReposErrorCode.fetch_repo_error);
      }
    }
  }

  Stream<SavedReposState> _createRepo(GithubRepo repo) async* {
    if (state.stateType == SavedReposStateType.loading) {
      return;
    }
    var currentState = state;
    currentState = currentState.update(
        stateType: SavedReposStateType.loading,
        errorMsg: "",
        errorCode: SavedReposErrorCode.none);
    yield currentState;
    final savedRepo = SavedRepo((b) => b
      ..id = "${repo.id}"
      ..fullName = repo.fullName
      ..createdAt = repo.createdAt
      ..stargazersCount = repo.stargazersCount
      ..language = repo.language
      ..url = repo.url);
    try {
      await _repoServerApiService.createRepo(savedRepo);
      var updatedResults = [...currentState.results, savedRepo];
      var sortedResults = updatedResults;
      if (currentState.sortByStars) {
        sortedResults.sortByStars();
      }
      yield currentState.update(
          stateType: SavedReposStateType.display_saved_repos,
          results: updatedResults,
          currentResults: sortedResults);
    } catch (e) {
      yield currentState.update(
          stateType: SavedReposStateType.display_saved_repos,
          errorMsg: e.toString(),
          errorCode: SavedReposErrorCode.create_repo_error,
          repoToCreate: savedRepo);
    }
  }

  Stream<SavedReposState> _deleteRepo(String repoId) async* {
    if (state.stateType == SavedReposStateType.loading) {
      return;
    }
    var currentState = state;
    currentState = currentState.update(
        stateType: SavedReposStateType.loading,
        errorMsg: "",
        errorCode: SavedReposErrorCode.none);
    yield currentState;
    try {
      await _repoServerApiService.deleteRepo(repoId);
      final updatedResults = [...currentState.results];
      final updatedCurrentResults = [...currentState.currentResults];
      updatedResults.removeWhere((savedRepo) => savedRepo.id == repoId);
      updatedCurrentResults.removeWhere((savedRepo) => savedRepo.id == repoId);
      yield currentState.update(
          stateType: updatedResults.length == 0
              ? SavedReposStateType.no_saved_repos
              : SavedReposStateType.display_saved_repos,
          results: updatedResults,
          currentResults: updatedCurrentResults);
    } catch (e) {
      yield currentState.update(
          stateType: SavedReposStateType.display_saved_repos,
          errorMsg: e.toString(),
          errorCode: SavedReposErrorCode.delete_repo_error,
          repoId: repoId);
    }
  }
}
