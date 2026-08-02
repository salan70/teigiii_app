//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

enum WordRegistrationResult {
  @JsonValue(r'created')
  created(r'created'),
  @JsonValue(r'promoted')
  promoted(r'promoted'),
  @JsonValue(r'alreadyPublic')
  alreadyPublic(r'alreadyPublic');

  const WordRegistrationResult(this.value);

  final String value;

  @override
  String toString() => value;
}
