import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../util/constant/firestore_collections.dart';

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

  /// [UserProfile] の初期値（初回登録時に保存する値）
  factory UserProfile.defaultValue(String userId, String imageUrl) {
    return UserProfile(
      id: userId,
      publicId: '',
      name: defaultName,
      bio: defaultBio,
      profileImageUrl: imageUrl,
      croppedFile: null,
    );
  }

  /// [name]の初期値
  static String get defaultName => '新人さん';

  /// [bio]の初期値
  static String get defaultBio => '';

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
    return List.generate(publicIdLength, (_) => Random.secure().nextInt(10))
        .join();
  }

  /// Firestore に保存する用の Map を返す
  /// 
  /// [publicId] は生成後に存在するか確認する必要があるため、未指定
  Map<String, dynamic> toFirestoreForCreate() {
    return {
      UserProfilesCollection.name: name,
      UserProfilesCollection.bio: bio,
      UserProfilesCollection.profileImageUrl: profileImageUrl,
    };
  }
}
