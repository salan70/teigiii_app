//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:teigiii_api/src/model/definition_status.dart';
import 'package:teigiii_api/src/model/user_summary.dart';
import 'package:teigiii_api/src/model/word_summary.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'definition_response.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DefinitionResponse {
  /// Returns a new [DefinitionResponse] instance.
  DefinitionResponse({
    required this.id,

    required this.word,

    required this.author,

    required this.body,

    required this.status,

    required this.isEdited,

    required this.likesCount,

    required this.isLikedByMe,

    required this.finalizedAt,

    required this.editableUntil,

    required this.createdAt,

    required this.updatedAt,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'word', required: true, includeIfNull: false)
  final WordSummary word;

  @JsonKey(name: r'author', required: true, includeIfNull: false)
  final UserSummary author;

  @JsonKey(name: r'body', required: true, includeIfNull: false)
  final String body;

  @JsonKey(name: r'status', required: true, includeIfNull: false)
  final DefinitionStatus status;

  @JsonKey(name: r'isEdited', required: true, includeIfNull: false)
  final bool isEdited;

  @JsonKey(name: r'likesCount', required: true, includeIfNull: false)
  final int likesCount;

  @JsonKey(name: r'isLikedByMe', required: true, includeIfNull: false)
  final bool isLikedByMe;

  @JsonKey(name: r'finalizedAt', required: true, includeIfNull: false)
  final DateTime finalizedAt;

  @JsonKey(name: r'editableUntil', required: true, includeIfNull: false)
  final DateTime editableUntil;

  @JsonKey(name: r'createdAt', required: true, includeIfNull: false)
  final DateTime createdAt;

  @JsonKey(name: r'updatedAt', required: true, includeIfNull: false)
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefinitionResponse &&
          other.id == id &&
          other.word == word &&
          other.author == author &&
          other.body == body &&
          other.status == status &&
          other.isEdited == isEdited &&
          other.likesCount == likesCount &&
          other.isLikedByMe == isLikedByMe &&
          other.finalizedAt == finalizedAt &&
          other.editableUntil == editableUntil &&
          other.createdAt == createdAt &&
          other.updatedAt == updatedAt;

  @override
  int get hashCode =>
      id.hashCode +
      word.hashCode +
      author.hashCode +
      body.hashCode +
      status.hashCode +
      isEdited.hashCode +
      likesCount.hashCode +
      isLikedByMe.hashCode +
      finalizedAt.hashCode +
      editableUntil.hashCode +
      createdAt.hashCode +
      updatedAt.hashCode;

  factory DefinitionResponse.fromJson(Map<String, dynamic> json) =>
      _$DefinitionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DefinitionResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
