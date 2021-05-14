import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_client.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_repo.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';

class SearchReposAutoComplete extends StatefulWidget {
  const SearchReposAutoComplete({Key? key}) : super(key: key);

  @override
  _SearchReposAutoCompleteState createState() =>
      _SearchReposAutoCompleteState();
}

class _SearchReposAutoCompleteState extends State<SearchReposAutoComplete> {
  SuggestionsBoxController _suggestionsBoxController =
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
        hideOnLoading: true,
        hideOnError: true,
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(
              "${suggestion.fullName}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${suggestion.desc}"),
                SizedBox(
                  height: 8,
                ),
                Text("${suggestion.language}"),
                SizedBox(
                  height: 8,
                ),
                Text("Stars: ${suggestion.stargazersCount}"),
              ],
            ),
          );
        },
        onSuggestionSelected: (suggestion) {
          _suggestionsBoxController.close();
          savedReposBloc..add(SavedReposEvent.createRepo(suggestion));
        });
  }
}
