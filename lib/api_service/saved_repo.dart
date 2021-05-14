import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:the_infatuation_coding_challenge_flutter/serializers.dart';

part 'saved_repo.g.dart';

abstract class SavedRepo implements Built<SavedRepo, SavedRepoBuilder> {
  SavedRepo._();

  factory SavedRepo([updates(SavedRepoBuilder b)]) = _$SavedRepo;

  @BuiltValueField(wireName: 'id')
  String get id;

  @BuiltValueField(wireName: 'fullName')
  String get fullName;

  @BuiltValueField(wireName: 'createdAt')
  String get createdAt;

  @BuiltValueField(wireName: 'stargazersCount')
  int get stargazersCount;

  @BuiltValueField(wireName: 'language')
  String get language;

  @BuiltValueField(wireName: 'url')
  String get url;

  String toJson() {
    return json.encode(toJsonMap());
  }

  Object? toJsonMap() {
    return serializers.serializeWith(SavedRepo.serializer, this);
  }

  static SavedRepo? fromJson(String jsonString) {
    return fromJsonMap(json.decode(jsonString));
  }

  static SavedRepo? fromJsonMap(Map<String, dynamic> decodedMap) {
    return serializers.deserializeWith(SavedRepo.serializer, decodedMap);
  }

  static Serializer<SavedRepo> get serializer => _$savedRepoSerializer;
}

extension SavedRepoExtension on SavedRepo {
  DateTime get createdAtDate => DateTime.parse(createdAt);
}

extension SavedRepoListExtension on List<SavedRepo> {
  void sortByStars() {
    this.sort((left, right) => right.stargazersCount - left.stargazersCount);
  }
}
