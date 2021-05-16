// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_repo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SavedRepo> _$savedRepoSerializer = new _$SavedRepoSerializer();

class _$SavedRepoSerializer implements StructuredSerializer<SavedRepo> {
  @override
  final Iterable<Type> types = const [SavedRepo, _$SavedRepo];
  @override
  final String wireName = 'SavedRepo';

  @override
  Iterable<Object?> serialize(Serializers serializers, SavedRepo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'fullName',
      serializers.serialize(object.fullName,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'stargazersCount',
      serializers.serialize(object.stargazersCount,
          specifiedType: const FullType(int)),
      'language',
      serializers.serialize(object.language,
          specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  SavedRepo deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SavedRepoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'fullName':
          result.fullName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'stargazersCount':
          result.stargazersCount = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'language':
          result.language = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$SavedRepo extends SavedRepo {
  @override
  final String id;
  @override
  final String fullName;
  @override
  final String createdAt;
  @override
  final int stargazersCount;
  @override
  final String language;
  @override
  final String url;

  factory _$SavedRepo([void Function(SavedRepoBuilder)? updates]) =>
      (new SavedRepoBuilder()..update(updates)).build() as _$SavedRepo;

  _$SavedRepo._(
      {required this.id,
      required this.fullName,
      required this.createdAt,
      required this.stargazersCount,
      required this.language,
      required this.url})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, 'SavedRepo', 'id');
    BuiltValueNullFieldError.checkNotNull(fullName, 'SavedRepo', 'fullName');
    BuiltValueNullFieldError.checkNotNull(createdAt, 'SavedRepo', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(
        stargazersCount, 'SavedRepo', 'stargazersCount');
    BuiltValueNullFieldError.checkNotNull(language, 'SavedRepo', 'language');
    BuiltValueNullFieldError.checkNotNull(url, 'SavedRepo', 'url');
  }

  @override
  SavedRepo rebuild(void Function(SavedRepoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$SavedRepoBuilder toBuilder() => new _$SavedRepoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SavedRepo &&
        id == other.id &&
        fullName == other.fullName &&
        createdAt == other.createdAt &&
        stargazersCount == other.stargazersCount &&
        language == other.language &&
        url == other.url;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, id.hashCode), fullName.hashCode),
                    createdAt.hashCode),
                stargazersCount.hashCode),
            language.hashCode),
        url.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SavedRepo')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('createdAt', createdAt)
          ..add('stargazersCount', stargazersCount)
          ..add('language', language)
          ..add('url', url))
        .toString();
  }
}

class _$SavedRepoBuilder extends SavedRepoBuilder {
  _$SavedRepo? _$v;

  @override
  String? get id {
    _$this;
    return super.id;
  }

  @override
  set id(String? id) {
    _$this;
    super.id = id;
  }

  @override
  String? get fullName {
    _$this;
    return super.fullName;
  }

  @override
  set fullName(String? fullName) {
    _$this;
    super.fullName = fullName;
  }

  @override
  String? get createdAt {
    _$this;
    return super.createdAt;
  }

  @override
  set createdAt(String? createdAt) {
    _$this;
    super.createdAt = createdAt;
  }

  @override
  int get stargazersCount {
    _$this;
    return super.stargazersCount;
  }

  @override
  set stargazersCount(int stargazersCount) {
    _$this;
    super.stargazersCount = stargazersCount;
  }

  @override
  String? get language {
    _$this;
    return super.language;
  }

  @override
  set language(String? language) {
    _$this;
    super.language = language;
  }

  @override
  String? get url {
    _$this;
    return super.url;
  }

  @override
  set url(String? url) {
    _$this;
    super.url = url;
  }

  _$SavedRepoBuilder() : super._();

  SavedRepoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      super.id = $v.id;
      super.fullName = $v.fullName;
      super.createdAt = $v.createdAt;
      super.stargazersCount = $v.stargazersCount;
      super.language = $v.language;
      super.url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SavedRepo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SavedRepo;
  }

  @override
  void update(void Function(SavedRepoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SavedRepo build() {
    final _$result = _$v ??
        new _$SavedRepo._(
            id: BuiltValueNullFieldError.checkNotNull(id, 'SavedRepo', 'id'),
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, 'SavedRepo', 'fullName'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, 'SavedRepo', 'createdAt'),
            stargazersCount: BuiltValueNullFieldError.checkNotNull(
                stargazersCount, 'SavedRepo', 'stargazersCount'),
            language: BuiltValueNullFieldError.checkNotNull(
                language, 'SavedRepo', 'language'),
            url:
                BuiltValueNullFieldError.checkNotNull(url, 'SavedRepo', 'url'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
