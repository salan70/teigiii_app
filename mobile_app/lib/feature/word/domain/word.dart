import 'package:freezed_annotation/freezed_annotation.dart';

part 'word.freezed.dart';

@freezed
class Word with _$Word {
  const factory Word({
    required String id,
    required String word,
    required String reading,
    required String initialSubGroupLabel,
    required int postedDefinitionCount,
    @Default(false) bool isSavedByMe,
    @Default(false) bool isEditableByMe,
  }) = _Word;
}
