import 'package:bloc_test/bloc_test.dart';
import 'package:fimber/fimber.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';

import '../mocks.dart';

void main() {
  group("SavedReposBloc fetch saved repos tests.", () {
    const mock_exception_msg = "Mock Exception!";
    final mockException = Exception(mock_exception_msg);
    late MockRepoServerApiService mockApiService;
    final MockSavedRepo mockSavedRepo = MockSavedRepo();
    final MockSavedRepo mockSecondSavedRepo = MockSavedRepo();

    setUp(() {
      Fimber.plantTree(DebugTree(printTimeType: DebugTree.timeClockType));
      mockApiService = MockRepoServerApiService();
      when(() => mockApiService.savedRepos).thenAnswer(
          (invocation) => Future.value([mockSavedRepo, mockSecondSavedRepo]));
    });

    tearDown(() {
      Fimber.clearAll();
      reset(mockSavedRepo);
      reset(mockSecondSavedRepo);
    });

    group("When sending a \"fetch_saved_repos\" event.", () {
      blocTest<SavedReposBloc, SavedReposState>(
        "Should fetch saved repos.",
        build: () => SavedReposBloc(mockApiService),
        act: (bloc) {
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[
          SavedReposState(stateType: SavedReposStateType.loading),
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        ],
        verify: (bloc) {
          verify(() => mockApiService.savedRepos);
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should start fetching saved repos once.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(stateType: SavedReposStateType.loading),
        act: (bloc) {
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[],
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should require force-refresh when refreshing from error.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.error,
            errorCode: SavedReposErrorCode.fetch_repo_error,
            errorMsg: "Some Error Message"),
        act: (bloc) {
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[],
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should require force-refresh when already displaying saved repos.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            results: [mockSavedRepo, mockSecondSavedRepo],
            currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        act: (bloc) {
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[],
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should fetch saved repos and sort them by stargazers count.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.initial, sortByStars: true),
        act: (bloc) {
          when(() => mockSecondSavedRepo.stargazersCount).thenReturn(20);
          when(() => mockSavedRepo.stargazersCount).thenReturn(10);
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.loading, sortByStars: true),
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              sortByStars: true,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSecondSavedRepo, mockSavedRepo]),
        ],
        verify: (bloc) {
          verify(() => mockApiService.savedRepos);
          verify(() => mockSavedRepo.stargazersCount);
          verify(() => mockSecondSavedRepo.stargazersCount);
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should return no saved repos.",
        build: () => SavedReposBloc(mockApiService),
        act: (bloc) {
          when(() => mockApiService.savedRepos)
              .thenAnswer((invocation) => Future.value([]));
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[
          SavedReposState(stateType: SavedReposStateType.loading),
          SavedReposState(stateType: SavedReposStateType.no_saved_repos),
        ],
        verify: (bloc) {
          verify(() => mockApiService.savedRepos);
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should handle error.",
        build: () => SavedReposBloc(mockApiService),
        act: (bloc) {
          when(() => mockApiService.savedRepos)
              .thenAnswer((invocation) => Future.error(mockException));
          bloc.add(SavedReposEvent.fetchSavedRepos());
        },
        expect: () => <SavedReposState>[
          SavedReposState(stateType: SavedReposStateType.loading),
          SavedReposState(
              stateType: SavedReposStateType.error,
              errorCode: SavedReposErrorCode.fetch_repo_error,
              errorMsg: "Exception: $mock_exception_msg"),
        ],
        verify: (bloc) {
          verify(() => mockApiService.savedRepos);
        },
      );

      group("When force-fetching saved repos.", () {
        final MockSavedRepo mockOtherRepo = MockSavedRepo();
        final MockSavedRepo mockSecondOtherRepo = MockSavedRepo();
        setUp(() {
          when(() => mockApiService.savedRepos).thenAnswer((invocation) =>
              Future.value([mockOtherRepo, mockSecondOtherRepo]));
        });

        tearDown(() {
          reset(mockOtherRepo);
          reset(mockSecondOtherRepo);
        });

        blocTest<SavedReposBloc, SavedReposState>(
          "Should fetch saved repos.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
          act: (bloc) {
            bloc.add(SavedReposEvent.fetchSavedRepos(forceRefresh: true));
          },
          expect: () => <SavedReposState>[
            SavedReposState(
                stateType: SavedReposStateType.loading,
                results: [mockSavedRepo, mockSecondSavedRepo],
                currentResults: [mockSavedRepo, mockSecondSavedRepo]),
            SavedReposState(
                stateType: SavedReposStateType.display_saved_repos,
                results: [mockOtherRepo, mockSecondOtherRepo],
                currentResults: [mockOtherRepo, mockSecondOtherRepo]),
          ],
          verify: (bloc) {
            verify(() => mockApiService.savedRepos);
          },
        );

        blocTest<SavedReposBloc, SavedReposState>(
          "Should fetch saved repos from error.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.error,
              errorCode: SavedReposErrorCode.fetch_repo_error,
              errorMsg: "Exception: $mock_exception_msg"),
          act: (bloc) {
            bloc.add(SavedReposEvent.fetchSavedRepos(forceRefresh: true));
          },
          expect: () => <SavedReposState>[
            SavedReposState(stateType: SavedReposStateType.loading),
            SavedReposState(
                stateType: SavedReposStateType.display_saved_repos,
                results: [mockOtherRepo, mockSecondOtherRepo],
                currentResults: [mockOtherRepo, mockSecondOtherRepo]),
          ],
          verify: (bloc) {
            verify(() => mockApiService.savedRepos);
          },
        );

        blocTest<SavedReposBloc, SavedReposState>(
          "Should fetch saved repos from no saved repos.",
          build: () => SavedReposBloc(mockApiService),
          seed: () =>
              SavedReposState(stateType: SavedReposStateType.no_saved_repos),
          act: (bloc) {
            bloc.add(SavedReposEvent.fetchSavedRepos(forceRefresh: true));
          },
          expect: () => <SavedReposState>[
            SavedReposState(stateType: SavedReposStateType.loading),
            SavedReposState(
                stateType: SavedReposStateType.display_saved_repos,
                results: [mockOtherRepo, mockSecondOtherRepo],
                currentResults: [mockOtherRepo, mockSecondOtherRepo]),
          ],
          verify: (bloc) {
            verify(() => mockApiService.savedRepos);
          },
        );

        group("When pulling to refresh.", () {
          blocTest<SavedReposBloc, SavedReposState>(
            "Should fetch saved repos.",
            build: () => SavedReposBloc(mockApiService),
            seed: () => SavedReposState(
                stateType: SavedReposStateType.display_saved_repos,
                results: [mockSavedRepo, mockSecondSavedRepo],
                currentResults: [mockSavedRepo, mockSecondSavedRepo]),
            act: (bloc) {
              bloc.add(SavedReposEvent.fetchSavedRepos(
                  forceRefresh: true, pullToRefresh: true));
            },
            expect: () => <SavedReposState>[
              SavedReposState(
                  stateType: SavedReposStateType.pull_to_refresh,
                  results: [mockSavedRepo, mockSecondSavedRepo],
                  currentResults: [mockSavedRepo, mockSecondSavedRepo]),
              SavedReposState(
                  stateType: SavedReposStateType.display_saved_repos,
                  results: [mockOtherRepo, mockSecondOtherRepo],
                  currentResults: [mockOtherRepo, mockSecondOtherRepo]),
            ],
            verify: (bloc) {
              verify(() => mockApiService.savedRepos);
            },
          );

          blocTest<SavedReposBloc, SavedReposState>(
            "Should fail to fetch saved repos.",
            build: () => SavedReposBloc(mockApiService),
            act: (bloc) {
              when(() => mockApiService.savedRepos)
                  .thenAnswer((invocation) => Future.error(mockException));
              bloc.add(SavedReposEvent.fetchSavedRepos(
                  forceRefresh: true, pullToRefresh: true));
            },
            expect: () => <SavedReposState>[
              SavedReposState(stateType: SavedReposStateType.loading),
              SavedReposState(
                  stateType: SavedReposStateType.error,
                  errorCode: SavedReposErrorCode.fetch_repo_error,
                  errorMsg: "Exception: $mock_exception_msg"),
            ],
            verify: (bloc) {
              verify(() => mockApiService.savedRepos);
            },
          );

          blocTest<SavedReposBloc, SavedReposState>(
            "Should fetch saved repos from error.",
            build: () => SavedReposBloc(mockApiService),
            seed: () => SavedReposState(
                stateType: SavedReposStateType.error,
                errorCode: SavedReposErrorCode.fetch_repo_error,
                errorMsg: "Exception: $mock_exception_msg"),
            act: (bloc) {
              bloc.add(SavedReposEvent.fetchSavedRepos(
                  forceRefresh: true, pullToRefresh: true));
            },
            expect: () => <SavedReposState>[
              SavedReposState(stateType: SavedReposStateType.loading),
              SavedReposState(
                  stateType: SavedReposStateType.display_saved_repos,
                  results: [mockOtherRepo, mockSecondOtherRepo],
                  currentResults: [mockOtherRepo, mockSecondOtherRepo]),
            ],
            verify: (bloc) {
              verify(() => mockApiService.savedRepos);
            },
          );

          blocTest<SavedReposBloc, SavedReposState>(
            "Should fetch saved repos from no saved repos.",
            build: () => SavedReposBloc(mockApiService),
            seed: () =>
                SavedReposState(stateType: SavedReposStateType.no_saved_repos),
            act: (bloc) {
              bloc.add(SavedReposEvent.fetchSavedRepos(
                  forceRefresh: true, pullToRefresh: true));
            },
            expect: () => <SavedReposState>[
              SavedReposState(stateType: SavedReposStateType.loading),
              SavedReposState(
                  stateType: SavedReposStateType.display_saved_repos,
                  results: [mockOtherRepo, mockSecondOtherRepo],
                  currentResults: [mockOtherRepo, mockSecondOtherRepo]),
            ],
            verify: (bloc) {
              verify(() => mockApiService.savedRepos);
            },
          );

          blocTest<SavedReposBloc, SavedReposState>(
            "Should revert to previous state when failing to fetch saved repos.",
            build: () => SavedReposBloc(mockApiService),
            seed: () => SavedReposState(
                stateType: SavedReposStateType.display_saved_repos,
                results: [mockSavedRepo, mockSecondSavedRepo],
                currentResults: [mockSavedRepo, mockSecondSavedRepo]),
            act: (bloc) {
              when(() => mockApiService.savedRepos)
                  .thenAnswer((invocation) => Future.error(mockException));
              bloc.add(SavedReposEvent.fetchSavedRepos(
                  forceRefresh: true, pullToRefresh: true));
            },
            expect: () => <SavedReposState>[
              SavedReposState(
                  stateType: SavedReposStateType.pull_to_refresh,
                  results: [mockSavedRepo, mockSecondSavedRepo],
                  currentResults: [mockSavedRepo, mockSecondSavedRepo]),
              SavedReposState(
                  stateType: SavedReposStateType.display_saved_repos,
                  results: [mockSavedRepo, mockSecondSavedRepo],
                  currentResults: [mockSavedRepo, mockSecondSavedRepo]),
            ],
            verify: (bloc) {
              verify(() => mockApiService.savedRepos);
            },
          );
        });
      });
    });
  });
}
