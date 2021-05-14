import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_client.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_repo.dart';

part 'search_repos_event.dart';
part 'search_repos_state.dart';

class SearchReposBloc extends Bloc<SearchReposEvent, SearchReposState> {
  SearchReposBloc(this._githubClient) : super(SearchReposState.initial());
  final GithubClient _githubClient;

  @override
  Stream<Transition<SearchReposEvent, SearchReposState>> transformEvents(
    Stream<SearchReposEvent> events,
    Stream<Transition<SearchReposEvent, SearchReposState>> Function(
      SearchReposEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<SearchReposState> mapEventToState(
    SearchReposEvent event,
  ) async* {
    if (event is TextChanged) {
      final searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield state.update(
            stateType: SearchReposStateType.empty_text,
            query: searchTerm,
            errorMsg: "");
      } else {
        var currentState = state;
        currentState = currentState.update(
            stateType: SearchReposStateType.loading,
            query: searchTerm,
            errorMsg: "");
        yield currentState;
        try {
          final resp = await _githubClient.search(searchTerm);
          final results = resp.items;
          if (results.isNotEmpty) {
            currentState = currentState.update(
                stateType: SearchReposStateType.results, repos: results);
          } else {
            currentState =
                currentState.update(stateType: SearchReposStateType.no_results);
          }
          yield currentState;
        } catch (error) {
          currentState = currentState.update(
              stateType: SearchReposStateType.error,
              errorMsg: error.toString());
          yield currentState;
        }
      }
    }
  }
}
