import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/github/github_client.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/reposerver_api_service.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';
import 'package:the_infatuation_coding_challenge_flutter/widgets/saved_repos_view.dart';
import 'package:the_infatuation_coding_challenge_flutter/widgets/search_repos_autocomplete.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Fimber.plantTree(DebugTree(printTimeType: DebugTree.timeClockType));
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details, forceReport: true);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  bool isAndroidSim = false;
  if (Platform.isAndroid) {
    // We check if we're running on Android simulator so that we can change
    // out the localhost value to 10.0.2.2 which is specific to
    // the android sim.
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceData = await deviceInfoPlugin.androidInfo;
    isAndroidSim = !deviceData.isPhysicalDevice;
  }
  runApp(MyApp(
    isAndroidSim: isAndroidSim,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  const MyApp({Key? key, required this.isAndroidSim}) : super(key: key);

  final bool isAndroidSim;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GithubClient>(
          create: (context) => GithubClient(),
        ),
        Provider<RepoServerApiService>(
          create: (context) => RepoServerApiService(isAndroidSim: isAndroidSim),
        ),
        BlocProvider<SavedReposBloc>(create: (context) {
          final repoServerApiService = context.read<RepoServerApiService>();
          return SavedReposBloc(repoServerApiService)
            ..add(SavedReposEvent.fetchSavedRepos());
        })
      ],
      child: MaterialApp(
        title: 'The Infatuation Coding Challenge',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'The Infatuation Coding Challenge'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: SearchReposAutoComplete()),
                SizedBox(
                  width: 8,
                ),
                BlocBuilder<SavedReposBloc, SavedReposState>(
                  builder: (context, state) => PlatformSwitch(
                      value: state.sortByStars,
                      onChanged: (_) {
                        context
                            .read<SavedReposBloc>()
                            .add(SavedReposEvent.toggleSortByStars());
                      }),
                )
              ],
            ),
          ),
          Expanded(child: SavedReposView())
        ],
      ),
    );
  }
}
