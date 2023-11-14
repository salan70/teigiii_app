import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';

part 'user_profile.freezed.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String publicId,
    required String name,
    required String bio,
    required String profileImageUrl,

    /// アップロード用にユーザーが指定したファイル（画像）を保持する
    required CroppedFile? croppedFile,
  }) = _UserProfile;
  const UserProfile._();

  /// [name]の初期値
  static String get defaultName => '見習い辞書編纂者';

  /// [bio]の初期値
  static String get defaultBio => '';

  /// [profileImageUrl]の初期値
  static String get defaultImageUrl => '';

  int get maxNameLength => 15;
  int get maxBioLength => 150;
  static int get publicIdLength => 9;

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

  /// UIで表示するように加工した[publicId]
  ///
  /// publicIdを3桁毎に区切った文字列を返す
  String get publicIdForUi {
    return publicId.replaceAllMapped(
      RegExp(r'(.{3})(?!$)'),
      (match) => '${match.group(0)}-',
    );
  }

  /// [publicId]を生成する
  static String generatePublicId() {
    // 9桁のランダムな数字を生成し、文字列に変換したものを返す
    return List.generate(publicIdLength, (_) => Random.secure().nextInt(10)).join();
  }
}
