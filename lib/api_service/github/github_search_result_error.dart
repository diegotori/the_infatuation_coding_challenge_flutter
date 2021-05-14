import 'package:equatable/equatable.dart';

class GithubSearchResultError extends Equatable {
  const GithubSearchResultError({required this.message});

  final String message;

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
