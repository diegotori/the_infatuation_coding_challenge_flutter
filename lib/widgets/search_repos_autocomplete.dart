import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_client.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_repo.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';
import 'package:the_infatuation_coding_challenge_flutter/widgets/github_repo_row.dart';

class SearchReposAutoComplete extends StatefulWidget {
  const SearchReposAutoComplete({Key? key}) : super(key: key);

  @override
  _SearchReposAutoCompleteState createState() =>
      _SearchReposAutoCompleteState();
}

class _SearchReposAutoCompleteState extends State<SearchReposAutoComplete> {
  final SuggestionsBoxController _suggestionsBoxController =
      SuggestionsBoxController();
  @override
  Widget build(BuildContext context) {
    final savedReposBloc = context.read<SavedReposBloc>();
    final githubClient = context.read<GithubClient>();
    return TypeAheadField<GithubRepo>(
        suggestionsBoxController: _suggestionsBoxController,
        debounceDuration: const Duration(milliseconds: 500),
        suggestionsCallback: (pattern) async {
          return await githubClient
              .search(pattern)
              .then((value) => value.items);
        },
        hideOnError: true,
        itemBuilder: (context, suggestion) {
          return GithubRepoRow(
            fullName: suggestion.fullName,
            desc: suggestion.desc,
            language: suggestion.language,
            stargazersCount: suggestion.stargazersCount,
          );
        },
        onSuggestionSelected: (suggestion) {
          _suggestionsBoxController.close();
          savedReposBloc..add(SavedReposEvent.createRepo(suggestion));
        });
  }
}
