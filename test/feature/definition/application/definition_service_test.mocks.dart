// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/definition/application/definition_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i7;
import 'package:teigi_app/feature/definition/repository/definition_repository.dart'
    as _i4;
import 'package:teigi_app/feature/definition/repository/entity/definition_document.dart'
    as _i3;

import 'definition_service_test.dart' as _i6;

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

/// A class which mocks [DefinitionRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDefinitionRepository extends _i1.Mock
    implements _i4.DefinitionRepository {
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
  _i5.Future<List<String>> fetchHomeRecommendDefinitionIdList(
          List<String>? mutedUserIdList) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeRecommendDefinitionIdList,
          [mutedUserIdList],
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);

  @override
  _i5.Future<List<String>> fetchHomeFollowingDefinitionList(
          List<String>? targetUserIdList) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchHomeFollowingDefinitionList,
          [targetUserIdList],
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
        returnValueForMissingStub: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);

  @override
  _i5.Future<_i3.DefinitionDocument> fetchDefinition(String? definitionId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchDefinition,
          [definitionId],
        ),
        returnValue:
            _i5.Future<_i3.DefinitionDocument>.value(_FakeDefinitionDocument_1(
          this,
          Invocation.method(
            #fetchDefinition,
            [definitionId],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.DefinitionDocument>.value(_FakeDefinitionDocument_1(
          this,
          Invocation.method(
            #fetchDefinition,
            [definitionId],
          ),
        )),
      ) as _i5.Future<_i3.DefinitionDocument>);

  @override
  _i5.Future<void> likeDefinition(
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> unlikeDefinition(
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<bool> isLikedByUser(
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
        returnValue: _i5.Future<bool>.value(false),
        returnValueForMissingStub: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);
}

/// A class which mocks [Listener].
///
/// See the documentation for Mockito's code generation for more information.
class MockListener extends _i1.Mock
    implements _i6.Listener<_i7.AsyncValue<void>> {
  @override
  void call(
    _i7.AsyncValue<void>? previous,
    _i7.AsyncValue<void>? next,
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