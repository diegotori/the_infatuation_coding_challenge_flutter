import 'package:equatable/equatable.dart';

///
/// Represents the error returned from searching for GitHub repositories.
///
class GithubSearchResultError extends Equatable {
  const GithubSearchResultError({required this.message});

  ///
  /// This instance's error message.
  ///
  final String message;

  ///
  /// Creates a new instance from the provided [json] [Map].
  ///
  static GithubSearchResultError fromJson(dynamic json) {
    return GithubSearchResultError(
      message: json['message'] as String,
    );
  }

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return 'GithubSearchResultError{message: $message}';
  }
}
