import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_for_write.freezed.dart';

@freezed
class UserProfileForWrite with _$UserProfileForWrite {
  const factory UserProfileForWrite({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,
  }) = _UserProfileForWrite;
  const UserProfileForWrite._();

  int get maxNameLength => 15;
  int get maxBioLength => 150;

  /// nameが無効な場合、エラーメッセージを返す
  String? outputNameError() {
    if (name.isEmpty) {
      return '名前を入力してください';
    }

    if (name.length > maxNameLength) {
      return '$maxNameLength文字以内で入力してください';
    }

    return null;
  }

  /// bioが無効な場合、エラーメッセージを返す
  String? outputBioError() {
    if (bio.length > maxBioLength) {
      return '$maxBioLength文字以内で入力してください';
    }

    return null;
  }

    /// 全てのフィールド（[name], [bio]）が有効かどうか
  bool isValidAllFields() {
    return outputNameError() == null && outputBioError() == null;
  }
}
