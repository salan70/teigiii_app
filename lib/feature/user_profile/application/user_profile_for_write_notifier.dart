import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/common_provider/is_loading_overlay_state.dart';
import '../../../core/common_provider/snack_bar_controller.dart';
import '../../../core/router/app_router.dart';
import '../../../util/logger.dart';
import '../../auth/application/auth_state.dart';
import '../domain/user_profile_for_write.dart';
import 'user_profile_state.dart';

part 'user_profile_for_write_notifier.g.dart';

@riverpod
class UserProfileForWriteNotifier extends _$UserProfileForWriteNotifier {
  @override
  FutureOr<UserProfileForWrite> build() async {
    final userId = ref.read(userIdProvider)!;
    final initialUserProfile =
        await ref.read(userProfileProvider(userId).future);

    return _initialState = initialUserProfile.toUserProfileForWrite();
  }

  /// 初期時の[UserProfileForWrite].
  /// 現在の状態と比較するために使用する
  late final UserProfileForWrite _initialState;

  void changeName(String name) {
    state = AsyncData(state.value!.copyWith(name: name));
  }

  void changeBio(String bio) {
    state = AsyncData(state.value!.copyWith(bio: bio));
  }

  void changeProfileImageUrl(String profileImageUrl) {
    // Storageやんなきゃ
    state = AsyncData(state.value!.copyWith(profileImageUrl: profileImageUrl));
  }

  Future<void> edit() async {
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();
    final snackBarNotifier = ref.read(snackBarControllerProvider.notifier);

    try {
      // 保存処理
    } on Exception catch (e) {
      logger.e('プロフィール編集時にエラーが発生 error: $e');
      snackBarNotifier.showSnackBar(
        '保存できませんでした。もう一度お試しください。',
        causeError: true,
      );
      isLoadingOverlayNotifier.finishLoading();
      return;
    }

    // 遷移元の画面を更新するためにinvalidateする
    // ref.invalidate(userProfileProvider());

    isLoadingOverlayNotifier.finishLoading();
    await ref.read(appRouterProvider).pop();
    snackBarNotifier.showSnackBar('保存しました！', causeError: false);
  }

  bool canEdit() {
    // canPost()を呼んだ方がいいかも
    return state.value!.isValidAllFields() && isChanged();
  }

  bool isChanged() {
    return state.value != _initialState;
  }
}
