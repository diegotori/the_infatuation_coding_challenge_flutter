import 'package:bloc_test/bloc_test.dart';
import 'package:fimber/fimber.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';

import '../mocks.dart';

void main() {
  group("SavedReposBloc delete repo tests.", () {
    const mock_repo_id = "12345678";
    const mock_second_repo_id = "87654321";
    const mock_exception_msg = "Mock Exception!";
    final mockException = Exception(mock_exception_msg);

    late MockRepoServerApiService mockApiService;
    final MockSavedRepo mockSavedRepo = MockSavedRepo();
    final MockSavedRepo mockSecondSavedRepo = MockSavedRepo();

    setUp(() {
      Fimber.plantTree(DebugTree(printTimeType: DebugTree.timeClockType));
      mockApiService = MockRepoServerApiService();
      when(() => mockSavedRepo.id).thenReturn(mock_repo_id);
      when(() => mockSecondSavedRepo.id).thenReturn(mock_second_repo_id);
      when(() => mockApiService.deleteRepo(any(that: isNotEmpty)))
          .thenAnswer((invocation) => Future.value(""));
    });

    tearDown(() {
      Fimber.clearAll();
      reset(mockSavedRepo);
      reset(mockSecondSavedRepo);
    });

    group("When sending a \"delete_repo\" event.", () {
      blocTest<SavedReposBloc, SavedReposState>(
        "Should delete repo.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            results: [mockSavedRepo, mockSecondSavedRepo],
            currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        act: (bloc) {
          bloc.add(SavedReposEvent.deleteRepo(mock_repo_id));
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.loading,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockSecondSavedRepo],
              currentResults: [mockSecondSavedRepo]),
        ],
        verify: (bloc) {
          verify(() => mockApiService.deleteRepo(any(that: isNotEmpty)));
          verify(() => mockSavedRepo.id);
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should not delete repo while loading.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.loading,
            results: [mockSavedRepo, mockSecondSavedRepo],
            currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        act: (bloc) {
          bloc.add(SavedReposEvent.deleteRepo(mock_repo_id));
        },
        expect: () => <SavedReposState>[],
        verify: (bloc) {
          verifyNever(() => mockApiService.deleteRepo(any(that: isNotEmpty)));
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should verify deleted repo ID.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            results: [mockSavedRepo, mockSecondSavedRepo],
            currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        act: (bloc) {
          bloc.add(SavedReposEvent.deleteRepo(mock_repo_id));
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.loading,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockSecondSavedRepo],
              currentResults: [mockSecondSavedRepo]),
        ],
        verify: (bloc) {
          verify(() => mockSavedRepo.id);
          final actualRepoId = verify(
                  () => mockApiService.deleteRepo(captureAny(that: isNotEmpty)))
              .captured
              .first as String;
          expect(actualRepoId, mock_repo_id);
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should delete last repo.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            results: [mockSavedRepo],
            currentResults: [mockSavedRepo]),
        act: (bloc) {
          bloc.add(SavedReposEvent.deleteRepo(mock_repo_id));
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.loading,
              results: [mockSavedRepo],
              currentResults: [mockSavedRepo]),
          SavedReposState(
              stateType: SavedReposStateType.no_saved_repos,
              results: [],
              currentResults: []),
        ],
        verify: (bloc) {
          verify(() => mockApiService.deleteRepo(any(that: isNotEmpty)));
          verify(() => mockSavedRepo.id);
        },
      );

      blocTest<SavedReposBloc, SavedReposState>(
        "Should fail to delete repo.",
        build: () => SavedReposBloc(mockApiService),
        seed: () => SavedReposState(
            stateType: SavedReposStateType.display_saved_repos,
            results: [mockSavedRepo, mockSecondSavedRepo],
            currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        act: (bloc) {
          when(() => mockApiService.deleteRepo(any(that: isNotEmpty)))
              .thenAnswer((invocation) => Future.error(mockException));
          bloc.add(SavedReposEvent.deleteRepo(mock_repo_id));
        },
        expect: () => <SavedReposState>[
          SavedReposState(
              stateType: SavedReposStateType.loading,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
          SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              errorMsg: "Exception: $mock_exception_msg",
              errorCode: SavedReposErrorCode.delete_repo_error,
              results: [mockSavedRepo, mockSecondSavedRepo],
              currentResults: [mockSavedRepo, mockSecondSavedRepo]),
        ],
        verify: (bloc) {
          verify(() => mockApiService.deleteRepo(any(that: isNotEmpty)));
          verifyNever(() => mockSavedRepo.id);
        },
      );
    });
  });
}
