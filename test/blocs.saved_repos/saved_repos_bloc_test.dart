import 'package:bloc_test/bloc_test.dart';
import 'package:fimber/fimber.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';

import '../mocks.dart';

void main() {
  group("SavedReposBloc tests.", () {
    const mock_exception_msg = "Mock Exception!";
    final MockSavedRepo mockSavedRepo = MockSavedRepo();
    final MockSavedRepo mockSecondSavedRepo = MockSavedRepo();
    late MockRepoServerApiService mockApiService;

    setUp(() {
      Fimber.plantTree(DebugTree(printTimeType: DebugTree.timeClockType));
      mockApiService = MockRepoServerApiService();
    });

    tearDown(() {
      Fimber.clearAll();
      reset(mockSavedRepo);
      reset(mockSecondSavedRepo);
    });
    group("When sending a \"clear_error_code\" event.", () {
      blocTest<SavedReposBloc, SavedReposState>(
        "Should clear the error code.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            errorMsg: mock_exception_msg,
            errorCode: SavedReposErrorCode.create_repo_error),
        act: (bloc) {
          bloc.add(SavedReposEvent.clearErrorCode());
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              errorMsg: "",
              errorCode: SavedReposErrorCode.none),
        ],
      );
    });

    group("When sending a \"toggle_sort_by_stars\" event.", () {
      blocTest<SavedReposBloc, SavedReposState>(
          "Should toggle sorting by stars to enabled.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              sortByStars: false,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
          act: (bloc) {
            when(() => mockSecondSavedRepo.stargazersCount).thenReturn(24);
            when(() => mockSavedRepo.stargazersCount).thenReturn(12);
            bloc.add(SavedReposEvent.toggleSortByStars());
          },
          expect: () => <SavedReposState>[
                SavedReposState(
                    stateType: SavedReposStateType.display_saved_repos,
                    sortByStars: true,
                    results: [mockSavedRepo, mockSecondSavedRepo],
                    currentResults: [mockSecondSavedRepo, mockSavedRepo]),
              ],
          verify: (bloc) {
            verify(() => mockSecondSavedRepo.stargazersCount);
            verify(() => mockSavedRepo.stargazersCount);
          });

      blocTest<SavedReposBloc, SavedReposState>(
        "Should toggle sorting by stars to disabled.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            sortByStars: true,
            results: [mockSavedRepo, mockSecondSavedRepo],
            currentResults: [mockSecondSavedRepo, mockSavedRepo]),
        act: (bloc) {
          bloc.add(SavedReposEvent.toggleSortByStars());
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              sortByStars: false,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        ],
      );
    });
  });
}
