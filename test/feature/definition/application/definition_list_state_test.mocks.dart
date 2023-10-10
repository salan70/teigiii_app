// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/definition/application/definition_list_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i12;
import 'package:teigi_app/feature/definition/domain/definition.dart' as _i13;
import 'package:teigi_app/feature/definition/repository/definition_repository.dart'
    as _i6;
import 'package:teigi_app/feature/definition/repository/entity/definition_document.dart'
    as _i3;
import 'package:teigi_app/feature/definition/util/definition_feed_type.dart'
    as _i8;
import 'package:teigi_app/feature/user/repository/entity/user_document.dart'
    as _i4;
import 'package:teigi_app/feature/user/repository/user_repository.dart' as _i9;
import 'package:teigi_app/feature/word/repository/entity/word_document.dart'
    as _i5;
import 'package:teigi_app/feature/word/repository/word_repository.dart' as _i10;

import 'definition_list_state_test.dart' as _i11;

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

class _FakeDefinitionDocument_1 extends _i1.SmartFake
    implements _i3.DefinitionDocument {
  _FakeDefinitionDocument_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserDocument_2 extends _i1.SmartFake implements _i4.UserDocument {
  _FakeUserDocument_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWordDocument_3 extends _i1.SmartFake implements _i5.WordDocument {
  _FakeWordDocument_3(
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
    implements _i6.DefinitionRepository {
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
  _i7.Future<List<_i3.DefinitionDocument>> fetchHomeRecommendDefinitionList(
    _i8.DefinitionFeedType? feedType,
    List<String>? mutedUserIdList,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeRecommendDefinitionList,
          [
            feedType,
            mutedUserIdList,
          ],
        ),
        returnValue: _i7.Future<List<_i3.DefinitionDocument>>.value(
            <_i3.DefinitionDocument>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i3.DefinitionDocument>>.value(
                <_i3.DefinitionDocument>[]),
      ) as _i7.Future<List<_i3.DefinitionDocument>>);

  @override
  _i7.Future<List<_i3.DefinitionDocument>> fetchHomeFollowingDefinitionList(
    _i8.DefinitionFeedType? feedType,
    List<String>? userIdList,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeFollowingDefinitionList,
          [
            feedType,
            userIdList,
          ],
        ),
        returnValue: _i7.Future<List<_i3.DefinitionDocument>>.value(
            <_i3.DefinitionDocument>[]),
        returnValueForMissingStub:
            _i7.Future<List<_i3.DefinitionDocument>>.value(
                <_i3.DefinitionDocument>[]),
      ) as _i7.Future<List<_i3.DefinitionDocument>>);

  @override
  _i7.Future<_i3.DefinitionDocument> fetchDefinition(String? definitionId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchDefinition,
          [definitionId],
        ),
        returnValue:
            _i7.Future<_i3.DefinitionDocument>.value(_FakeDefinitionDocument_1(
          this,
          Invocation.method(
            #fetchDefinition,
            [definitionId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i3.DefinitionDocument>.value(_FakeDefinitionDocument_1(
          this,
          Invocation.method(
            #fetchDefinition,
            [definitionId],
          ),
        )),
      ) as _i7.Future<_i3.DefinitionDocument>);

  @override
  _i7.Future<void> likeDefinition(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> unlikeDefinition(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<bool> isLikedByUser(
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
        returnValue: _i7.Future<bool>.value(false),
        returnValueForMissingStub: _i7.Future<bool>.value(false),
      ) as _i7.Future<bool>);
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i9.UserRepository {
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
  _i7.Future<_i4.UserDocument> fetchUser(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #fetchUser,
          [userId],
        ),
        returnValue: _i7.Future<_i4.UserDocument>.value(_FakeUserDocument_2(
          this,
          Invocation.method(
            #fetchUser,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i4.UserDocument>.value(_FakeUserDocument_2(
          this,
          Invocation.method(
            #fetchUser,
            [userId],
          ),
        )),
      ) as _i7.Future<_i4.UserDocument>);

  @override
  _i7.Future<List<String>> fetchFollowingIdList(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchFollowingIdList,
          [userId],
        ),
        returnValue: _i7.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i7.Future<List<String>>.value(<String>[]),
      ) as _i7.Future<List<String>>);
}

/// A class which mocks [WordRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWordRepository extends _i1.Mock implements _i10.WordRepository {
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
  _i7.Future<_i5.WordDocument> fetchWord(String? wordId) => (super.noSuchMethod(
        Invocation.method(
          #fetchWord,
          [wordId],
        ),
        returnValue: _i7.Future<_i5.WordDocument>.value(_FakeWordDocument_3(
          this,
          Invocation.method(
            #fetchWord,
            [wordId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i5.WordDocument>.value(_FakeWordDocument_3(
          this,
          Invocation.method(
            #fetchWord,
            [wordId],
          ),
        )),
      ) as _i7.Future<_i5.WordDocument>);
}

/// A class which mocks [ChangeListener].
///
/// See the documentation for Mockito's code generation for more information.
class MockChangeListener extends _i1.Mock
    implements _i11.ChangeListener<_i12.AsyncValue<List<_i13.Definition>>> {
  @override
  void call(
    _i12.AsyncValue<List<_i13.Definition>>? previous,
    _i12.AsyncValue<List<_i13.Definition>>? next,
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
