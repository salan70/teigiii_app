// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/definition_list/application/definition_id_list_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i20;
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart'
    as _i9;
import 'package:teigi_app/feature/definition/repository/write_definition_repository.dart'
    as _i7;
import 'package:teigi_app/feature/definition_list/domain/definition_id_list_state.dart'
    as _i3;
import 'package:teigi_app/feature/definition_list/repository/definition_id_list_repository.dart'
    as _i10;
import 'package:teigi_app/feature/definition_list/util/definition_feed_type.dart'
    as _i11;
import 'package:teigi_app/feature/user_config/repository/entity/user_config_document.dart'
    as _i5;
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart'
    as _i15;
import 'package:teigi_app/feature/user_follow/repository/entity/user_follow_count_document.dart'
    as _i6;
import 'package:teigi_app/feature/user_follow/repository/user_follow_repository.dart'
    as _i16;
import 'package:teigi_app/feature/user_profile/domain/user_profile.dart'
    as _i14;
import 'package:teigi_app/feature/user_profile/repository/entity/user_profile_document.dart'
    as _i4;
import 'package:teigi_app/feature/user_profile/repository/user_profile_repository.dart'
    as _i13;
import 'package:teigi_app/feature/word/repository/entity/word_document.dart'
    as _i18;
import 'package:teigi_app/feature/word/repository/word_repository.dart' as _i17;
import 'package:teigi_app/util/constant/initial_main_group.dart' as _i12;

import 'definition_id_list_state_test.dart' as _i19;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseFirestore_0 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDefinitionIdListState_1 extends _i1.SmartFake
    implements _i3.DefinitionIdListState {
  _FakeDefinitionIdListState_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserProfileDocument_2 extends _i1.SmartFake
    implements _i4.UserProfileDocument {
  _FakeUserProfileDocument_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserConfigDocument_3 extends _i1.SmartFake
    implements _i5.UserConfigDocument {
  _FakeUserConfigDocument_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserFollowCountDocument_4 extends _i1.SmartFake
    implements _i6.UserFollowCountDocument {
  _FakeUserFollowCountDocument_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [WriteDefinitionRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWriteDefinitionRepository extends _i1.Mock
    implements _i7.WriteDefinitionRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<String> createDefinition(
    _i9.DefinitionForWrite? definitionForWrite,
    String? wordId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createDefinition,
          [
            definitionForWrite,
            wordId,
          ],
        ),
        returnValue: _i8.Future<String>.value(''),
        returnValueForMissingStub: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);

  @override
  _i8.Future<String> createDefinitionAndWord(
          _i9.DefinitionForWrite? definitionForWrite) =>
      (super.noSuchMethod(
        Invocation.method(
          #createDefinitionAndWord,
          [definitionForWrite],
        ),
        returnValue: _i8.Future<String>.value(''),
        returnValueForMissingStub: _i8.Future<String>.value(''),
      ) as _i8.Future<String>);

  @override
  _i8.Future<void> updateDefinition(
          _i9.DefinitionForWrite? definitionForWrite) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateDefinition,
          [definitionForWrite],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> updateWordChangedDefinition(
    String? previousWordId,
    String? newWordId,
    _i9.DefinitionForWrite? definitionForWrite,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateWordChangedDefinition,
          [
            previousWordId,
            newWordId,
            definitionForWrite,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> updateDefinitionAndCreateWord(
    _i9.DefinitionForWrite? definitionForWrite,
    String? previousWordId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateDefinitionAndCreateWord,
          [
            definitionForWrite,
            previousWordId,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> deleteDefinition(
    String? definitionId,
    String? wordId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteDefinition,
          [
            definitionId,
            wordId,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> updatePostType({
    required String? definitionId,
    required bool? isPublic,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePostType,
          [],
          {
            #definitionId: definitionId,
            #isPublic: isPublic,
          },
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [DefinitionIdListRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefinitionIdListRepository extends _i1.Mock
    implements _i10.DefinitionIdListRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i3.DefinitionIdListState> fetchForHomeRecommend(
    String? currentUserId,
    List<String>? mutedUserIdList,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchForHomeRecommend,
          [
            currentUserId,
            mutedUserIdList,
            lastDocument,
          ],
        ),
        returnValue: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForHomeRecommend,
            [
              currentUserId,
              mutedUserIdList,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForHomeRecommend,
            [
              currentUserId,
              mutedUserIdList,
              lastDocument,
            ],
          ),
        )),
      ) as _i8.Future<_i3.DefinitionIdListState>);

  @override
  _i8.Future<_i3.DefinitionIdListState> fetchForHomeFollowing(
    String? currentUserId,
    List<String>? targetUserIdList,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchForHomeFollowing,
          [
            currentUserId,
            targetUserIdList,
            lastDocument,
          ],
        ),
        returnValue: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForHomeFollowing,
            [
              currentUserId,
              targetUserIdList,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForHomeFollowing,
            [
              currentUserId,
              targetUserIdList,
              lastDocument,
            ],
          ),
        )),
      ) as _i8.Future<_i3.DefinitionIdListState>);

  @override
  _i8.Future<_i3.DefinitionIdListState> fetchForWordTop(
    _i11.WordTopOrderByType? orderByType,
    String? currentUserId,
    List<String>? mutedUserIdList,
    String? wordId,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchForWordTop,
          [
            orderByType,
            currentUserId,
            mutedUserIdList,
            wordId,
            lastDocument,
          ],
        ),
        returnValue: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForWordTop,
            [
              orderByType,
              currentUserId,
              mutedUserIdList,
              wordId,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForWordTop,
            [
              orderByType,
              currentUserId,
              mutedUserIdList,
              wordId,
              lastDocument,
            ],
          ),
        )),
      ) as _i8.Future<_i3.DefinitionIdListState>);

  @override
  _i8.Future<_i3.DefinitionIdListState> fetchForProfileCreatedAt(
    String? currentUserId,
    String? targetUserId,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchForProfileCreatedAt,
          [
            currentUserId,
            targetUserId,
            lastDocument,
          ],
        ),
        returnValue: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForProfileCreatedAt,
            [
              currentUserId,
              targetUserId,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForProfileCreatedAt,
            [
              currentUserId,
              targetUserId,
              lastDocument,
            ],
          ),
        )),
      ) as _i8.Future<_i3.DefinitionIdListState>);

  @override
  _i8.Future<_i3.DefinitionIdListState> fetchForLikedByUser(
    String? currentUserId,
    String? targetUserId,
    List<String>? mutedUserIdList,
    _i2.QueryDocumentSnapshot<Object?>? initialLastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchForLikedByUser,
          [
            currentUserId,
            targetUserId,
            mutedUserIdList,
            initialLastDocument,
          ],
        ),
        returnValue: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForLikedByUser,
            [
              currentUserId,
              targetUserId,
              mutedUserIdList,
              initialLastDocument,
            ],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForLikedByUser,
            [
              currentUserId,
              targetUserId,
              mutedUserIdList,
              initialLastDocument,
            ],
          ),
        )),
      ) as _i8.Future<_i3.DefinitionIdListState>);

  @override
  _i8.Future<_i3.DefinitionIdListState> fetchForIndividualDictionary(
    String? currentUserId,
    String? targetUserId,
    _i12.InitialSubGroup? initialSubGroup,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchForIndividualDictionary,
          [
            currentUserId,
            targetUserId,
            initialSubGroup,
            lastDocument,
          ],
        ),
        returnValue: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForIndividualDictionary,
            [
              currentUserId,
              targetUserId,
              initialSubGroup,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchForIndividualDictionary,
            [
              currentUserId,
              targetUserId,
              initialSubGroup,
              lastDocument,
            ],
          ),
        )),
      ) as _i8.Future<_i3.DefinitionIdListState>);
}

/// A class which mocks [UserProfileRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserProfileRepository extends _i1.Mock
    implements _i13.UserProfileRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i4.UserProfileDocument> fetchUserProfile(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserProfile,
          [userId],
        ),
        returnValue: _i8.Future<_i4.UserProfileDocument>.value(
            _FakeUserProfileDocument_2(
          this,
          Invocation.method(
            #fetchUserProfile,
            [userId],
          ),
        )),
        returnValueForMissingStub: _i8.Future<_i4.UserProfileDocument>.value(
            _FakeUserProfileDocument_2(
          this,
          Invocation.method(
            #fetchUserProfile,
            [userId],
          ),
        )),
      ) as _i8.Future<_i4.UserProfileDocument>);

  @override
  _i8.Future<void> updateUserProfile(_i14.UserProfile? userProfileForWrite) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserProfile,
          [userProfileForWrite],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> deleteUserProfile(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #deleteUserProfile,
          [userId],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [UserConfigRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserConfigRepository extends _i1.Mock
    implements _i15.UserConfigRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i5.UserConfigDocument> fetchUserConfig(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserConfig,
          [userId],
        ),
        returnValue:
            _i8.Future<_i5.UserConfigDocument>.value(_FakeUserConfigDocument_3(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i5.UserConfigDocument>.value(_FakeUserConfigDocument_3(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
      ) as _i8.Future<_i5.UserConfigDocument>);

  @override
  _i8.Future<void> appendMutedUserIdList(
    String? userId,
    String? mutedUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #appendMutedUserIdList,
          [
            userId,
            mutedUserId,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> removeMutedUserIdList(
    String? userId,
    String? mutedUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeMutedUserIdList,
          [
            userId,
            mutedUserId,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> deleteUserConfig(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #deleteUserConfig,
          [userId],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [UserFollowRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserFollowRepository extends _i1.Mock
    implements _i16.UserFollowRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i6.UserFollowCountDocument> fetchUserFollowCount(
          String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserFollowCount,
          [userId],
        ),
        returnValue: _i8.Future<_i6.UserFollowCountDocument>.value(
            _FakeUserFollowCountDocument_4(
          this,
          Invocation.method(
            #fetchUserFollowCount,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i8.Future<_i6.UserFollowCountDocument>.value(
                _FakeUserFollowCountDocument_4(
          this,
          Invocation.method(
            #fetchUserFollowCount,
            [userId],
          ),
        )),
      ) as _i8.Future<_i6.UserFollowCountDocument>);

  @override
  _i8.Future<void> follow(
    String? currentUserId,
    String? targetUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #follow,
          [
            currentUserId,
            targetUserId,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> unfollow(
    String? currentUserId,
    String? targetUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #unfollow,
          [
            currentUserId,
            targetUserId,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<bool> isFollowing(
    String? currentUserId,
    String? targetUserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #isFollowing,
          [
            currentUserId,
            targetUserId,
          ],
        ),
        returnValue: _i8.Future<bool>.value(false),
        returnValueForMissingStub: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<List<String>> fetchAllFollowingIdList(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchAllFollowingIdList,
          [userId],
        ),
        returnValue: _i8.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i8.Future<List<String>>.value(<String>[]),
      ) as _i8.Future<List<String>>);

  @override
  _i8.Future<void> deleteUserFollowCount(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #deleteUserFollowCount,
          [userId],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [WordRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordRepository extends _i1.Mock implements _i17.WordRepository {
  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
        returnValueForMissingStub: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i8.Future<_i18.WordDocument?> fetchWordById(String? wordId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchWordById,
          [wordId],
        ),
        returnValue: _i8.Future<_i18.WordDocument?>.value(),
        returnValueForMissingStub: _i8.Future<_i18.WordDocument?>.value(),
      ) as _i8.Future<_i18.WordDocument?>);

  @override
  _i8.Future<String?> findWordId(
    String? word,
    String? wordReading,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #findWordId,
          [
            word,
            wordReading,
          ],
        ),
        returnValue: _i8.Future<String?>.value(),
        returnValueForMissingStub: _i8.Future<String?>.value(),
      ) as _i8.Future<String?>);
}

/// A class which mocks [Listener].
///
/// See the documentation for Mockito's code generation for more information.
class MockListener extends _i1.Mock
    implements _i19.Listener<_i20.AsyncValue<_i3.DefinitionIdListState>> {
  @override
  void call(
    _i20.AsyncValue<_i3.DefinitionIdListState>? previous,
    _i20.AsyncValue<_i3.DefinitionIdListState>? next,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #call,
          [
            previous,
            next,
          ],
        ),
        returnValueForMissingStub: null,
      );
}