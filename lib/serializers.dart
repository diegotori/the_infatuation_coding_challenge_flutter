library serializers;

import 'package:built_value/serializer.dart';
import 'package:the_infatuation_coding_challenge_flutter/api_service/saved_repo.dart';

part 'serializers.g.dart';

@SerializersFor([SavedRepo])
final Serializers serializers = _$serializers;
