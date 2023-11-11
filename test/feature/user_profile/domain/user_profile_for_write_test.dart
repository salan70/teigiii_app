import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart';

void main() {
  group('UserProfileForWrite Tests', () {
    const defaultUserProfileForWrite = UserProfile(
      id: 'userId',
      name: 'ヒトカゲ',
      bio: '早くリザードになりたい',
      profileImageUrl: 'https://example.com/profile.jpg',
      croppedFile: null,
    );

    group('outputNameError()', () {
      test('有効な値', () {
        // * Arrange
        const userProfile = defaultUserProfileForWrite;

        // * Act
        final result = userProfile.outputNameError();

        // * Assert
        expect(result, isNull);
      });

      test('空', () {
        // * Arrange
        final userProfile = defaultUserProfileForWrite.copyWith(name: '');

        // * Act
        final result = userProfile.outputNameError();

        // * Assert
        expect(result, '名前を入力してください');
      });

      test('最大文字数を超えている', () {
        // * Arrange
        final longName = 'a' *
            (defaultUserProfileForWrite.maxNameLength +
                1); // maxNameLengthより1文字多い
        final userProfile = defaultUserProfileForWrite.copyWith(name: longName);

        // * Act
        final result = userProfile.outputNameError();

        // * Assert
        expect(result, '${userProfile.maxNameLength}文字以内で入力してください');
      });
    });

    group('outputBioError()', () {
      test('有効な値', () {
        // * Arrange
        const userProfile = defaultUserProfileForWrite;

        // * Act
        final result = userProfile.outputBioError();

        // * Assert
        expect(result, isNull);
      });

      test('最大文字数を超えている', () {
        // * Arrange
        final longBio = 'a' *
            (defaultUserProfileForWrite.maxBioLength +
                1); // maxBioLengthより1文字多い
        final userProfile = defaultUserProfileForWrite.copyWith(bio: longBio);

        // * Act
        final result = userProfile.outputBioError();

        // * Assert
        expect(result, '${userProfile.maxBioLength}文字以内で入力してください');
      });
    });

    group('isValidAllFields()', () {
      test('全て有効な値', () {
        // * Arrange
        const userProfile = defaultUserProfileForWrite;

        // * Act
        final result = userProfile.isValidAllFields();

        // * Assert
        expect(result, isTrue);
      });
      test('nameが無効', () {
        // * Arrange
        const invalidName = ''; // 無効な名前
        final userProfile =
            defaultUserProfileForWrite.copyWith(name: invalidName);

        // * Act
        final result = userProfile.isValidAllFields();

        // * Assert
        expect(result, isFalse);
      });

      test('bioが無効', () {
        // * Arrange
        final invalidBio = 'a' *
            (defaultUserProfileForWrite.maxBioLength +
                1); // maxBioLengthより1文字多い
        final userProfile =
            defaultUserProfileForWrite.copyWith(bio: invalidBio);

        // * Act
        final result = userProfile.isValidAllFields();

        // * Assert
        expect(result, isFalse);
      });

      test('nameとbioが無効', () {
        // * Arrange
        const invalidName = ''; // 無効な名前
        final invalidBio = 'a' *
            (defaultUserProfileForWrite.maxBioLength +
                1); // maxBioLengthより1文字多い
        final userProfile = defaultUserProfileForWrite.copyWith(
          name: invalidName,
          bio: invalidBio,
        );

        // * Act
        final result = userProfile.isValidAllFields();

        // * Assert
        expect(result, isFalse);
      });
    });
  });
}
