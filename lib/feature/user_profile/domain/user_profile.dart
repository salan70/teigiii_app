import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String bio,
    required String profileImageUrl,

    /// アップロード用にユーザーが指定したファイル（画像）を保持する
    required CroppedFile? croppedFile,
  }) = _UserProfile;
  const UserProfile._();

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
