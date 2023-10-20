// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/definition/application/definition_id_list_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i9;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i14;
import 'package:teigi_app/feature/definition/domain/definition_id_list_state.dart'
    as _i3;
import 'package:teigi_app/feature/definition/repository/definition_repository.dart'
    as _i8;
import 'package:teigi_app/feature/definition/repository/entity/definition_document.dart'
    as _i4;
import 'package:teigi_app/feature/user/repository/entity/user_profile_document.dart'
    as _i5;
import 'package:teigi_app/feature/user/repository/user_profile_repository.dart'
    as _i10;
import 'package:teigi_app/feature/user_config/repository/entity/user_config_document.dart'
    as _i6;
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart'
    as _i11;
import 'package:teigi_app/feature/word/repository/entity/word_document.dart'
    as _i7;
import 'package:teigi_app/feature/word/repository/word_repository.dart' as _i12;

import 'definition_id_list_state_test.dart' as _i13;

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

class _FakeDefinitionDocument_2 extends _i1.SmartFake
    implements _i4.DefinitionDocument {
  _FakeDefinitionDocument_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserProfileDocument_3 extends _i1.SmartFake
    implements _i5.UserProfileDocument {
  _FakeUserProfileDocument_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserConfigDocument_4 extends _i1.SmartFake
    implements _i6.UserConfigDocument {
  _FakeUserConfigDocument_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWordDocument_5 extends _i1.SmartFake implements _i7.WordDocument {
  _FakeWordDocument_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DefinitionRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefinitionRepository extends _i1.Mock
    implements _i8.DefinitionRepository {
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
  _i9.Future<_i3.DefinitionIdListState> fetchHomeRecommendDefinitionIdListFirst(
          List<String>? mutedUserIdList) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeRecommendDefinitionIdListFirst,
          [mutedUserIdList],
        ),
        returnValue: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeRecommendDefinitionIdListFirst,
            [mutedUserIdList],
          ),
        )),
        returnValueForMissingStub: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeRecommendDefinitionIdListFirst,
            [mutedUserIdList],
          ),
        )),
      ) as _i9.Future<_i3.DefinitionIdListState>);

  @override
  _i9.Future<_i3.DefinitionIdListState> fetchHomeRecommendDefinitionIdListMore(
    List<String>? mutedUserIdList,
    _i2.QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeRecommendDefinitionIdListMore,
          [
            mutedUserIdList,
            lastReadQueryDocumentSnapshot,
          ],
        ),
        returnValue: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeRecommendDefinitionIdListMore,
            [
              mutedUserIdList,
              lastReadQueryDocumentSnapshot,
            ],
          ),
        )),
        returnValueForMissingStub: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeRecommendDefinitionIdListMore,
            [
              mutedUserIdList,
              lastReadQueryDocumentSnapshot,
            ],
          ),
        )),
      ) as _i9.Future<_i3.DefinitionIdListState>);

  @override
  _i9.Future<_i3.DefinitionIdListState> fetchHomeFollowingDefinitionIdListFirst(
          List<String>? targetUserIdList) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeFollowingDefinitionIdListFirst,
          [targetUserIdList],
        ),
        returnValue: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeFollowingDefinitionIdListFirst,
            [targetUserIdList],
          ),
        )),
        returnValueForMissingStub: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeFollowingDefinitionIdListFirst,
            [targetUserIdList],
          ),
        )),
      ) as _i9.Future<_i3.DefinitionIdListState>);

  @override
  _i9.Future<_i3.DefinitionIdListState> fetchHomeFollowingDefinitionIdListMore(
    List<String>? targetUserIdList,
    _i2.QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeFollowingDefinitionIdListMore,
          [
            targetUserIdList,
            lastReadQueryDocumentSnapshot,
          ],
        ),
        returnValue: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeFollowingDefinitionIdListMore,
            [
              targetUserIdList,
              lastReadQueryDocumentSnapshot,
            ],
          ),
        )),
        returnValueForMissingStub: _i9.Future<_i3.DefinitionIdListState>.value(
            _FakeDefinitionIdListState_1(
          this,
          Invocation.method(
            #fetchHomeFollowingDefinitionIdListMore,
            [
              targetUserIdList,
              lastReadQueryDocumentSnapshot,
            ],
          ),
        )),
      ) as _i9.Future<_i3.DefinitionIdListState>);

  @override
  _i9.Future<_i4.DefinitionDocument> fetchDefinition(String? definitionId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchDefinition,
          [definitionId],
        ),
        returnValue:
            _i9.Future<_i4.DefinitionDocument>.value(_FakeDefinitionDocument_2(
          this,
          Invocation.method(
            #fetchDefinition,
            [definitionId],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i4.DefinitionDocument>.value(_FakeDefinitionDocument_2(
          this,
          Invocation.method(
            #fetchDefinition,
            [definitionId],
          ),
        )),
      ) as _i9.Future<_i4.DefinitionDocument>);

  @override
  _i9.Future<void> likeDefinition(
    String? definitionId,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #likeDefinition,
          [
            definitionId,
            userId,
          ],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);

  @override
  _i9.Future<void> unlikeDefinition(
    String? definitionId,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #unlikeDefinition,
          [
            definitionId,
            userId,
          ],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);

  @override
  _i9.Future<bool> isLikedByUser(
    String? userId,
    String? definitionId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #isLikedByUser,
          [
            userId,
            definitionId,
          ],
        ),
        returnValue: _i9.Future<bool>.value(false),
        returnValueForMissingStub: _i9.Future<bool>.value(false),
      ) as _i9.Future<bool>);
}

/// A class which mocks [UserProfileRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserProfileRepository extends _i1.Mock
    implements _i10.UserProfileRepository {
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
  _i9.Future<_i5.UserProfileDocument> fetchUserProfile(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserProfile,
          [userId],
        ),
        returnValue: _i9.Future<_i5.UserProfileDocument>.value(
            _FakeUserProfileDocument_3(
          this,
          Invocation.method(
            #fetchUserProfile,
            [userId],
          ),
        )),
        returnValueForMissingStub: _i9.Future<_i5.UserProfileDocument>.value(
            _FakeUserProfileDocument_3(
          this,
          Invocation.method(
            #fetchUserProfile,
            [userId],
          ),
        )),
      ) as _i9.Future<_i5.UserProfileDocument>);

  @override
  _i9.Future<void> addUserProfile(
    String? userId,
    String? name,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addUserProfile,
          [
            userId,
            name,
          ],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);

  @override
  _i9.Future<List<String>> fetchFollowingIdList(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchFollowingIdList,
          [userId],
        ),
        returnValue: _i9.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i9.Future<List<String>>.value(<String>[]),
      ) as _i9.Future<List<String>>);
}

/// A class which mocks [UserConfigRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserConfigRepository extends _i1.Mock
    implements _i11.UserConfigRepository {
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
  _i9.Future<_i6.UserConfigDocument> fetchUserConfig(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserConfig,
          [userId],
        ),
        returnValue:
            _i9.Future<_i6.UserConfigDocument>.value(_FakeUserConfigDocument_4(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i6.UserConfigDocument>.value(_FakeUserConfigDocument_4(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
      ) as _i9.Future<_i6.UserConfigDocument>);

  @override
  _i9.Future<void> addUserConfig(
    String? userId,
    String? osVersion,
    String? appVersion,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addUserConfig,
          [
            userId,
            osVersion,
            appVersion,
          ],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);

  @override
  _i9.Future<void> updateUserConfig(
    String? userId,
    String? osVersion,
    String? appVersion,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateUserConfig,
          [
            userId,
            osVersion,
            appVersion,
          ],
        ),
        returnValue: _i9.Future<void>.value(),
        returnValueForMissingStub: _i9.Future<void>.value(),
      ) as _i9.Future<void>);
}

/// A class which mocks [WordRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordRepository extends _i1.Mock implements _i12.WordRepository {
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
  _i9.Future<_i7.WordDocument> fetchWord(String? wordId) => (super.noSuchMethod(
        Invocation.method(
          #fetchWord,
          [wordId],
        ),
        returnValue: _i9.Future<_i7.WordDocument>.value(_FakeWordDocument_5(
          this,
          Invocation.method(
            #fetchWord,
            [wordId],
          ),
        )),
        returnValueForMissingStub:
            _i9.Future<_i7.WordDocument>.value(_FakeWordDocument_5(
          this,
          Invocation.method(
            #fetchWord,
            [wordId],
          ),
        )),
      ) as _i9.Future<_i7.WordDocument>);
}

/// A class which mocks [Listener].
///
/// See the documentation for Mockito's code generation for more information.
class MockListener extends _i1.Mock
    implements _i13.Listener<_i14.AsyncValue<_i3.DefinitionIdListState>> {
  @override
  void call(
    _i14.AsyncValue<_i3.DefinitionIdListState>? previous,
    _i14.AsyncValue<_i3.DefinitionIdListState>? next,
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
