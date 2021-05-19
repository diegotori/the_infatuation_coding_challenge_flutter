import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:the_infatuation_coding_challenge_flutter/serializers.dart';

part 'saved_repo.g.dart';

///
/// Represents a Saved Repository from the backend.
///
abstract class SavedRepo implements Built<SavedRepo, SavedRepoBuilder> {
  SavedRepo._();

  factory SavedRepo([updates(SavedRepoBuilder b)]) = _$SavedRepo;

  ///
  /// This instance's Identifier.
  ///
  @BuiltValueField(wireName: 'id')
  String get id;

  ///
  /// This instance's Full Name.
  ///
  @BuiltValueField(wireName: 'fullName')
  String get fullName;

  ///
  /// This instance's Creation Date as an ISO-8601 timestamp value.
  ///
  @BuiltValueField(wireName: 'createdAt')
  String get createdAt;

  ///
  /// This instance's Stargazer Count.
  ///
  @BuiltValueField(wireName: 'stargazersCount')
  int get stargazersCount;

  ///
  /// This instance's Programming Language
  ///
  @BuiltValueField(wireName: 'language')
  String get language;

  ///
  /// This instance's URL.
  ///
  @BuiltValueField(wireName: 'url')
  String get url;

  ///
  /// Returns this instance as an encoded JSON [String].
  ///
  String toJson() {
    return json.encode(toJsonMap());
  }

  ///
  /// Returns this instance as a serialized raw JSON [Map].
  ///
  Object? toJsonMap() {
    return serializers.serializeWith(SavedRepo.serializer, this);
  }

  ///
  /// Creates a new instance from an encoded JSON [String].
  ///
  static SavedRepo? fromJson(String jsonString) {
    return fromJsonMap(json.decode(jsonString));
  }

  ///
  /// Creates a new instance from a serialized raw JSON [Map].
  ///
  static SavedRepo? fromJsonMap(Map<String, dynamic> decodedMap) {
    return serializers.deserializeWith(SavedRepo.serializer, decodedMap);
  }

  static Serializer<SavedRepo> get serializer => _$savedRepoSerializer;
}

///
/// Builds a new instance of [SavedRepo].
///
abstract class SavedRepoBuilder
    implements Builder<SavedRepo, SavedRepoBuilder> {
  /// The identifier to set.
  String? id;

  /// The Full Name to set.
  String? fullName;

  /// The Creation Date ISO-8601 timestamp value to set.
  String? createdAt;

  /// The Stargazer Count to set. Defaults to `0`.
  int stargazersCount = 0;

  /// The Programming Language to set.
  String? language;

  /// The URL to set.
  String? url;

  factory SavedRepoBuilder() = _$SavedRepoBuilder;
  SavedRepoBuilder._();
}

extension SavedRepoExtension on SavedRepo {
  /// Returns [createdAt] as a [DateTime].
  DateTime get createdAtDate => DateTime.parse(createdAt);
}

extension SavedRepoListExtension on List<SavedRepo> {
  /// Sorts this [SavedRepo] [List] by stargazer count, in descending order.
  void sortByStars() {
    this.sort((left, right) => right.stargazersCount - left.stargazersCount);
  }
}
