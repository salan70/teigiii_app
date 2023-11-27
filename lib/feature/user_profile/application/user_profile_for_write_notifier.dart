import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/toast_controller.dart';
import '../../../core/router/app_router.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../domain/user_profile.dart';
import '../repository/image_repository.dart';
import '../repository/storage_repository.dart';
import '../repository/user_profile_repository.dart';
import 'user_profile_state.dart';

part 'user_profile_for_write_notifier.g.dart';

/// UserProfileの更新に関する処理を行う
@riverpod
class UserProfileForWriteNotifier extends _$UserProfileForWriteNotifier {
  @override
  FutureOr<UserProfile> build() async {
    final userId = ref.read(userIdProvider)!;
    final initialUserProfile =
        await ref.read(userProfileProvider(userId).future);

    return _initialState = initialUserProfile;
  }

  /// 初期時の[UserProfile].
  /// 現在の状態と比較するために使用する
  late final UserProfile _initialState;

  void changeName(String name) {
    state = AsyncData(state.value!.copyWith(name: name));
  }

  void changeBio(String bio) {
    state = AsyncData(state.value!.copyWith(bio: bio));
  }

  void _changeProfileImageUrl(String profileImageUrl) {
    state = AsyncData(state.value!.copyWith(profileImageUrl: profileImageUrl));
  }

  Future<void> pickAndCropImage(ImageSource imageSource) async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    final imageRepository = ref.read(imageRepositoryProvider);

    // 画像を選択
    try {
      final pickedFile = await imageRepository.pickImage(imageSource);
      if (pickedFile == null) {
        isLoadingOverlayNotifier.finishLoading();
        return;
      }

      // 画像を切り抜き
      final croppedFile = await imageRepository.cropImage(pickedFile.path);
      if (croppedFile == null) {
        isLoadingOverlayNotifier.finishLoading();
        return;
      }
      state = AsyncData(state.value!.copyWith(croppedFile: croppedFile));
    } on Exception catch (e, stackTrace) {
      logger.e('画像選択もしくは切り抜き時にエラーが発生 error: $e, stackTrace: $stackTrace');

      ref
          .read(toastControllerProvider.notifier)
          .showToast('エラーが発生しました。もう一度お試しください');
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    isLoadingOverlayNotifier.finishLoading();
  }

  void resetCroppedFile() {
    state = AsyncData(state.value!.copyWith(croppedFile: null));
  }

  Future<void> edit() async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    final toastNotifier = ref.read(toastControllerProvider.notifier);

    try {
      // 新たに画像が選択されているかどうか
      if (state.value!.croppedFile != null) {
        // 画像をアップロードし、stateを更新
        final profileImageUrl = await _uploadImage();
        _changeProfileImageUrl(profileImageUrl);
      }

      // プロフィールを更新
      await ref.read(userProfileRepositoryProvider).updateUserProfile(
            state.value!,
          );

      // プロフィールを更新
    } on Exception catch (e, stackTrace) {
      logger.e('プロフィール編集時にエラーが発生 error: $e, stackTrace: $stackTrace');
      toastNotifier.showToast(
        '保存できませんでした。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // UIを更新するためにinvalidateする
    final userId = ref.read(userIdProvider)!;
    ref.invalidate(userProfileProvider(userId));

    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    toastNotifier.showToast('保存しました！');
  }

  /// 画像をアップロードし、ダウンロードURLを返す
  Future<String> _uploadImage() async {
    final userId = ref.read(userIdProvider)!;
    final file = File(state.value!.croppedFile!.path);
    return ref.read(storageRepositoryProvider).uploadFile(userId, file);
  }

  bool canEdit() {
    return state.value!.isValidAllFields() && isChanged();
  }

  bool isChanged() {
    return state.value != _initialState;
  }
}
