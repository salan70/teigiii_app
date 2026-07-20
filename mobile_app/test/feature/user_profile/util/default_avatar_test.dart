import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/user_profile/util/default_avatar.dart';

void main() {
  group('defaultAvatarAssetPath', () {
    test('同じ userId には常に同じ asset を返す（決定的であること）', () {
      // * Arrange
      const userId = 'abcDEF123';

      // * Act
      final first = defaultAvatarAssetPath(userId);
      final second = defaultAvatarAssetPath(userId);

      // * Assert
      expect(first, second);
    });

    test('返す asset は定義済みの 3 種のいずれかである', () {
      // * Arrange
      const userIdList = ['user1', 'user2', 'user3', 'あいうえお', ''];

      for (final userId in userIdList) {
        // * Act
        final assetPath = defaultAvatarAssetPath(userId);

        // * Assert
        expect(defaultAvatarAssetPaths, contains(assetPath));
      }
    });

    test('userId によって異なる asset が選ばれ得る（分散すること）', () {
      // * Arrange
      // 十分な数の userId を与えれば、3 種すべてが選ばれるはず
      final userIdList = List.generate(100, (i) => 'user$i');

      // * Act
      final selected = userIdList.map(defaultAvatarAssetPath).toSet();

      // * Assert
      expect(selected, defaultAvatarAssetPaths.toSet());
    });
  });
}
