part of 'search_repos_bloc.dart';

abstract class SearchReposEvent extends Equatable {
  const SearchReposEvent();
}

class TextChanged extends SearchReposEvent {
  const TextChanged({required this.text});

  final String text;

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}
