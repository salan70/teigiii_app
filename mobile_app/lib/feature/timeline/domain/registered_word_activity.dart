import 'package:freezed_annotation/freezed_annotation.dart';

part 'registered_word_activity.freezed.dart';

/// タイムラインに流れる「言葉が登録された」アクティビティ。
@freezed
class RegisteredWordActivity with _$RegisteredWordActivity {
  const factory RegisteredWordActivity({
    required String wordId,
    required String word,
    required String reading,
    required DateTime occurredAt,
  }) = _RegisteredWordActivity;
}
