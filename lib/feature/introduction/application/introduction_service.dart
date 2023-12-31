import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/app_router.dart';
import '../repository/is_first_launch_repository.dart';

part 'introduction_service.g.dart';

@riverpod
IntroductionService introductionService(IntroductionServiceRef ref) =>
    IntroductionService(ref);

class IntroductionService {
  IntroductionService(this.ref);

  final Ref ref;

  /// 利用規約とプライバシーポリシーに同意した直後に行う処理。
  ///
  /// 「アプリの初回起動が終えたことの保存」と「トラッキングダイアログの表示」を行い、
  /// それぞれの処理が完了したら[BaseRoute]に遷移する。
  Future<void> onAgreePolicy() async {
    // 初回起動フラグを保存する。
    await ref.read(isFirstLaunchRepositoryProvider).saveFirstLaunch();

    // トラッキングダイアログを表示する。
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
