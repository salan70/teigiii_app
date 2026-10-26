import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../../core/common_provider/firebase_providers.dart';
import '../../user_profile/domain/user_profile.dart';
import '../../user_profile/repository/user_profile_repository.dart';
import '../domain/account_data_snapshot.dart';

export '../domain/account_data_snapshot.dart';

part 'account_data_repository.g.dart';

@riverpod
AccountDataRepository accountDataRepository(AccountDataRepositoryRef ref) =>
    AccountDataRepository(
      ref.watch(teigiiiApiProvider).getMeApi(),
      ref.watch(userProfileRepositoryProvider),
      ref.watch(firebaseAuthProvider),
    );

class AccountDataRepository {
  AccountDataRepository(
    this._meApi,
    this._userProfileRepository,
    this._firebaseAuth,
  );

  final MeApi _meApi;
  final UserProfileRepository _userProfileRepository;
  final FirebaseAuth _firebaseAuth;

  Future<AccountDataSnapshot> fetchCurrentAccountData() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw StateError('現在のユーザーが存在しません。');
    }

    final overview = await _fetchDictionaryOverview();
    final profile = await _userProfileRepository.fetchUserProfile(userId);

    return AccountDataSnapshot(
      definedWordCount: overview.definedWordCount,
      savedWordCount: overview.savedWordCount,
      followingCount: profile.followingCount,
      hasEditedProfile:
          profile.name != UserProfile.defaultName ||
          profile.bio.isNotEmpty ||
          profile.avatarUrl != null,
    );
  }

  Future<MyDictionaryOverview> _fetchDictionaryOverview() async {
    try {
      final response = await _meApi.v1MeDictionaryOverviewGet();
      final overview = response.data;
      if (overview == null) {
        throw StateError('辞書概要が空です。');
      }
      return overview;
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
