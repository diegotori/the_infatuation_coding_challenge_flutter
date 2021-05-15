import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/saved_repo.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';
import 'package:the_infatuation_coding_challenge_flutter/widgets/github_repo_row.dart';
import 'package:the_infatuation_coding_challenge_flutter/widgets/simple_loading_spinner.dart';

class SavedReposView extends StatefulWidget {
  const SavedReposView({Key? key}) : super(key: key);

  @override
  _SavedReposViewState createState() => _SavedReposViewState();
}

class _SavedReposViewState extends State<SavedReposView> {
  final SlidableController slidableController = SlidableController();
  late Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedReposBloc, SavedReposState>(
        builder: (context, state) {
      final savedReposBloc = context.read<SavedReposBloc>();
      final SavedReposStateType stateType = state.stateType;
      final List<SavedRepo> savedRepos = state.currentResults;
      final bool isLoading = stateType == SavedReposStateType.loading;
      final bool isInitial = stateType == SavedReposStateType.initial;
      final bool hasNoSavedRepos =
          stateType == SavedReposStateType.no_saved_repos;
      final bool hasError = stateType == SavedReposStateType.error;
      final bool isLoaded =
          stateType == SavedReposStateType.display_saved_repos;
      if (isLoaded || hasNoSavedRepos || hasError) {
        // Hide our refresh indicator
        _refreshCompleter.complete();
        _refreshCompleter = Completer<void>();
      }

      Widget refreshChild = Container();
      if (hasNoSavedRepos || hasError) {
        refreshChild =
            _ErrorView(hasError: hasError, hasNoSavedRepos: hasNoSavedRepos);
      } else if (!(isInitial || isLoading)) {
        // Fade in the Result if available
        refreshChild = _SavedReposList(
            savedRepos: savedRepos, slidableController: slidableController);
      }
      return Stack(
        children: <Widget>[
          // Fade in a loading screen when results are being fetched
          // from VLE
          SimpleLoadingSpinner(
            visible: isLoading || isInitial,
          ),
          RefreshIndicator(
            onRefresh: () {
              savedReposBloc.add(SavedReposEvent.fetchSavedRepos(
                  forceRefresh: true, pullToRefresh: true));
              return _refreshCompleter.future;
            },
            child: refreshChild,
          ),
        ],
      );
    });
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    Key? key,
    required this.hasError,
    required this.hasNoSavedRepos,
  }) : super(key: key);

  final bool hasError;
  final bool hasNoSavedRepos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ThemeData currentTheme = Theme.of(context);
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: constraints.maxHeight,
            child: Stack(
              children: <Widget>[
                // Fade in an error if something went wrong when fetching
                // the results
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: hasError ? 1.0 : 0.0,
                  child: InkWell(
                    onTap: null,
                    child: Container(
                      alignment: FractionalOffset.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon((Icons.warning_rounded),
                              color: currentTheme.primaryColor, size: 80.0),
                          Container(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "There was a problem fetching Saved Repos.\n"
                              "Please Pull to Refresh to try again.",
                              textAlign: TextAlign.center,
                              style: currentTheme.textTheme.subtitle1!.copyWith(
                                  color: currentTheme.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Fade in an Empty Result screen if the search contained
                // no items
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: hasNoSavedRepos ? 1.0 : 0.0,
                  child: Container(
                      child: Center(
                          child: Text("There are no Saved Repos.",
                              style: currentTheme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600)))),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SavedReposList extends StatelessWidget {
  const _SavedReposList({
    Key? key,
    required this.savedRepos,
    required this.slidableController,
  }) : super(key: key);

  final List<SavedRepo> savedRepos;
  final SlidableController slidableController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          final savedRepo = savedRepos[index];
          return Slidable(
            controller: slidableController,
            secondaryActions: [
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  final shouldRemove = await showPlatformDialog<bool?>(
                    context: context,
                    builder: (_) => PlatformAlertDialog(
                      title: Text('Attention!'),
                      content: Text('Are you sure you want to delete '
                          'this Saved Repo?'),
                      actions: <Widget>[
                        PlatformDialogAction(
                          child: PlatformText('No'),
                          onPressed: () {
                            Navigator.pop<bool?>(context, false);
                          },
                        ),
                        PlatformDialogAction(
                          child: PlatformText('Yes'),
                          onPressed: () {
                            Navigator.pop<bool?>(context, true);
                          },
                        ),
                      ],
                    ),
                  );
                  if (shouldRemove != null && shouldRemove) {
                    context
                        .read<SavedReposBloc>()
                        .add(SavedReposEvent.deleteRepo(savedRepo.id));
                  }
                },
              )
            ],
            actionPane: SlidableBehindActionPane(),
            child: GithubRepoRow(
              fullName: savedRepo.fullName,
              language: savedRepo.language,
              stargazersCount: savedRepo.stargazersCount,
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
              height: 0,
            ),
        itemCount: savedRepos.length);
  }
}
