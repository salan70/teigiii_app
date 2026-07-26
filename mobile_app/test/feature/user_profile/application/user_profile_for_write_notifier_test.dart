import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/analytics/analytics_event.dart';
import 'package:teigi_app/feature/auth/application/auth_state.dart';
import 'package:teigi_app/feature/user_profile/application/user_profile_for_write_notifier.dart';
import 'package:teigi_app/feature/user_profile/repository/avatar_repository.dart';
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart';

import '../../../mock/fake_analytics.dart';
import '../../../mock/mock_data.dart';
import 'user_profile_for_write_notifier_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UserProfileRepository>(),
  MockSpec<AvatarRepository>(),
])
void main() {
  final mockUserProfileRepository = MockUserProfileRepository();
  final mockAvatarRepository = MockAvatarRepository();
  late ProviderContainer container;
  late FakeAnalyticsClient fakeAnalytics;
  late Directory tempDir;

  const fixedAvatarUrl = 'https://api.example.com/v1/avatars/userId';

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('avatar-test-');
    fakeAnalytics = FakeAnalyticsClient();
    final initialProfile = mockUserProfile.copyWith(avatarUrl: fixedAvatarUrl);
    when(
      mockUserProfileRepository.fetchUserProfile(any),
    ).thenAnswer((_) async => initialProfile);
    when(
      mockAvatarRepository.uploadAvatar(any),
    ).thenAnswer((_) async => fixedAvatarUrl);

    container = ProviderContainer(
      overrides: [
        userIdProvider.overrideWith((ref) => mockUserProfile.id),
        userProfileRepositoryProvider.overrideWithValue(
          mockUserProfileRepository,
        ),
        avatarRepositoryProvider.overrideWithValue(mockAvatarRepository),
        ...analyticsTestOverrides(fakeAnalytics),
      ],
    );
    addTearDown(container.dispose);
  });

  tearDown(() async {
    reset(mockUserProfileRepository);
    reset(mockAvatarRepository);
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('アバター URL が変わらなくても croppedFile があれば changed_avatar: true', () async {
    final subscription = container.listen(
      userProfileForWriteNotifierProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final notifier = container.read(
      userProfileForWriteNotifierProvider.notifier,
    );
    await container.read(userProfileForWriteNotifierProvider.future);

    final croppedPath = '${tempDir.path}/avatar.jpg';
    await File(croppedPath).writeAsBytes([0xFF, 0xD8, 0xFF]);
    await notifier.updateCroppedFileState(CroppedFile(croppedPath));
    expect(
      container.read(userProfileForWriteNotifierProvider).value?.croppedFile,
      isNotNull,
    );
    expect(
      container
          .read(userProfileForWriteNotifierProvider)
          .value
          ?.croppedImageBytes,
      isNotNull,
    );

    await notifier.edit();

    expect(
      fakeAnalytics.loggedEvents.single.name,
      AnalyticsEvent.profileUpdated,
    );
    expect(fakeAnalytics.loggedEvents.single.parameters, {
      AnalyticsParam.changedName: false,
      AnalyticsParam.changedBio: false,
      AnalyticsParam.changedAvatar: true,
    });
    verify(mockAvatarRepository.uploadAvatar(any)).called(1);
  });
}
