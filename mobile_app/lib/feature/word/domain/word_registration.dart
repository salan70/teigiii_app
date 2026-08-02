import 'package:freezed_annotation/freezed_annotation.dart';

import 'word.dart';

part 'word_registration.freezed.dart';

/// 明示登録がもたらした結果。
enum WordRegistrationOutcome {
  /// 言葉を新規に作成した。
  created,

  /// 既存の言葉だが、この登録で初めて公開された。
  promoted,

  /// 既存の言葉で、登録の前から公開されていた。
  ///
  /// 見た目に変化が起きない唯一の結果であり、成功として伝えてはいけない。
  alreadyPublic,
}

/// 言葉の明示登録の結果。
@freezed
class WordRegistration with _$WordRegistration {
  const factory WordRegistration({
    required Word word,
    required WordRegistrationOutcome outcome,
  }) = _WordRegistration;
}
