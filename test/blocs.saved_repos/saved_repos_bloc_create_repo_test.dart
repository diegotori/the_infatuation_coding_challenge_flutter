import 'package:bloc_test/bloc_test.dart';
import 'package:fimber/fimber.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/saved_repo.dart';
import 'package:the_infatuation_coding_challenge_flutter/blocs/saved_repos/saved_repos_bloc.dart';

import '../mocks.dart';

void main() {
  group("SavedReposBloc create saved repos tests.", () {
    const mock_existing_repo_id = 87654321;
    const mock_existing_repo_full_name = "flutter/flutter";
    const mock_existing_repo_stargazers_count = 24;
    const mock_existing_repo_language = "Dart";
    const mock_existing_repo_url =
        "https://api.github.com/repos/flutter/flutter";
    const mock_existing_repo_created_at = "2017-12-26T13:05:46Z";
    const mock_saved_repo_id = 12345678;
    const mock_saved_repo_full_name = "ethereum/go-ethereum";
    const mock_saved_repo_stargazers_count = 12;
    const mock_saved_repo_language = "Go";
    const mock_saved_repo_url =
        "https://api.github.com/repos/ethereum/go-ethereum";
    const mock_saved_repo_created_at = "2013-12-26T13:05:46Z";
    final SavedRepo mockRealSavedRepo = SavedRepo((b) => b
      ..id = "$mock_saved_repo_id"
      ..fullName = mock_saved_repo_full_name
      ..createdAt = mock_saved_repo_created_at
      ..stargazersCount = mock_saved_repo_stargazers_count
      ..language = mock_saved_repo_language
      ..url = mock_saved_repo_url);
    const mock_exception_msg = "Mock Exception!";
    final mockException = Exception(mock_exception_msg);
    late MockRepoServerApiService mockApiService;
    final MockSavedRepo mockExistingRepo = MockSavedRepo();
    final MockGithubRepo mockGithubRepo = MockGithubRepo();

    setUpAll(() {
      registerFallbackValue(MockSavedRepo());
    });

    setUp(() {
      Fimber.plantTree(DebugTree(printTimeType: DebugTree.timeClockType));
      mockApiService = MockRepoServerApiService();
      when(() => mockApiService.createRepo(any()))
          .thenAnswer((invocation) => Future.value(MockSavedRepo()));
      when(() => mockGithubRepo.id).thenReturn(mock_saved_repo_id);
      when(() => mockGithubRepo.fullName).thenReturn(mock_saved_repo_full_name);
      when(() => mockGithubRepo.createdAt)
          .thenReturn(mock_saved_repo_created_at);
      when(() => mockGithubRepo.stargazersCount)
          .thenReturn(mock_saved_repo_stargazers_count);
      when(() => mockGithubRepo.language).thenReturn(mock_saved_repo_language);
      when(() => mockGithubRepo.url).thenReturn(mock_saved_repo_url);
      when(() => mockExistingRepo.id).thenReturn("$mock_existing_repo_id");

      when(() => mockExistingRepo.fullName)
          .thenReturn(mock_existing_repo_full_name);
      when(() => mockExistingRepo.createdAt)
          .thenReturn(mock_existing_repo_created_at);
      when(() => mockExistingRepo.stargazersCount)
          .thenReturn(mock_existing_repo_stargazers_count);
      when(() => mockExistingRepo.language)
          .thenReturn(mock_existing_repo_language);
      when(() => mockExistingRepo.url).thenReturn(mock_existing_repo_url);
    });

    tearDown(() {
      Fimber.clearAll();
      reset(mockExistingRepo);
      reset(mockGithubRepo);
    });

    group("When sending a \"create_repo\" event.", () {
      blocTest<SavedReposBloc, SavedReposState>("Should create saved repo.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockExistingRepo],
              currentResults: [mockExistingRepo]),
          act: (bloc) {
            bloc.add(SavedReposEvent.createRepo(mockGithubRepo));
          },
          expect: () => <SavedReposState>[
                SavedReposState(
                    stateType: SavedReposStateType.loading,
                    results: [mockExistingRepo],
                    currentResults: [mockExistingRepo]),
                SavedReposState(
                    stateType: SavedReposStateType.display_saved_repos,
                    results: [mockExistingRepo, mockRealSavedRepo],
                    currentResults: [mockExistingRepo, mockRealSavedRepo])
              ],
          verify: (bloc) {
            verify(() => mockApiService.createRepo(any()));
            verify(() => mockGithubRepo.id);
            verify(() => mockGithubRepo.fullName);
            verify(() => mockGithubRepo.createdAt);
            verify(() => mockGithubRepo.stargazersCount);
            verify(() => mockGithubRepo.language);
            verify(() => mockGithubRepo.url);
          });

      blocTest<SavedReposBloc, SavedReposState>(
          "Should sort by stars after creating saved repo.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              sortByStars: true,
              results: [mockExistingRepo],
              currentResults: [mockExistingRepo]),
          act: (bloc) {
            when(() => mockExistingRepo.stargazersCount).thenReturn(24);
            bloc.add(SavedReposEvent.createRepo(mockGithubRepo));
          },
          expect: () => <SavedReposState>[
                SavedReposState(
                    stateType: SavedReposStateType.loading,
                    sortByStars: true,
                    results: [mockExistingRepo],
                    currentResults: [mockExistingRepo]),
                SavedReposState(
                    stateType: SavedReposStateType.display_saved_repos,
                    sortByStars: true,
                    results: [mockExistingRepo, mockRealSavedRepo],
                    currentResults: [mockExistingRepo, mockRealSavedRepo])
              ],
          verify: (bloc) {
            verify(() => mockApiService.createRepo(any()));
            verify(() => mockExistingRepo.stargazersCount);
          });

      blocTest<SavedReposBloc, SavedReposState>(
          "Should validate outgoing SavedRepo.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockExistingRepo],
              currentResults: [mockExistingRepo]),
          act: (bloc) {
            bloc.add(SavedReposEvent.createRepo(mockGithubRepo));
          },
          expect: () => <SavedReposState>[
                SavedReposState(
                    stateType: SavedReposStateType.loading,
                    results: [mockExistingRepo],
                    currentResults: [mockExistingRepo]),
                SavedReposState(
                    stateType: SavedReposStateType.display_saved_repos,
                    results: [mockExistingRepo, mockRealSavedRepo],
                    currentResults: [mockExistingRepo, mockRealSavedRepo])
              ],
          verify: (bloc) {
            final actualSavedRepo =
                verify(() => mockApiService.createRepo(captureAny()))
                    .captured
                    .first as SavedRepo;
            expect(actualSavedRepo, isNotNull);
            expect(actualSavedRepo.id, "$mock_saved_repo_id");
            expect(actualSavedRepo.fullName, mock_saved_repo_full_name);
            expect(actualSavedRepo.createdAt, mock_saved_repo_created_at);
            expect(actualSavedRepo.stargazersCount,
                mock_saved_repo_stargazers_count);
            expect(actualSavedRepo.language, mock_saved_repo_language);
            expect(actualSavedRepo.url, mock_saved_repo_url);
          });

      blocTest<SavedReposBloc, SavedReposState>(
          "Should fail to create saved repo.",
          build: () => SavedReposBloc(mockApiService),
          seed: () => SavedReposState(
              stateType: SavedReposStateType.display_saved_repos,
              results: [mockExistingRepo],
              currentResults: [mockExistingRepo]),
          act: (bloc) {
            when(() => mockApiService.createRepo(any()))
                .thenAnswer((invocation) => Future.error(mockException));
            bloc.add(SavedReposEvent.createRepo(mockGithubRepo));
          },
          expect: () => <SavedReposState>[
                SavedReposState(
                    stateType: SavedReposStateType.loading,
                    results: [mockExistingRepo],
                    currentResults: [mockExistingRepo]),
                SavedReposState(
                    stateType: SavedReposStateType.display_saved_repos,
                    errorMsg: "Exception: $mock_exception_msg",
                    errorCode: SavedReposErrorCode.create_repo_error,
                    repoToCreate: mockGithubRepo,
                    results: [mockExistingRepo],
                    currentResults: [mockExistingRepo])
              ],
          verify: (bloc) {
            verify(() => mockApiService.createRepo(any()));
          });
    });
  });
}
