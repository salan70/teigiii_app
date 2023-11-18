// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/definition/application/definition_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i7;
import 'package:teigi_app/feature/definition/domain/definition_for_write.dart'
    as _i5;
import 'package:teigi_app/feature/definition/repository/write_definition_repository.dart'
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

/// A class which mocks [WriteDefinitionRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWriteDefinitionRepository extends _i1.Mock
    implements _i3.WriteDefinitionRepository {
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
  _i4.Future<void> createDefinition(
    _i5.DefinitionForWrite? definitionForWrite,
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> createDefinitionAndWord(
          _i5.DefinitionForWrite? definitionForWrite) =>
      (super.noSuchMethod(
        Invocation.method(
          #createDefinitionAndWord,
          [definitionForWrite],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateDefinition(
          _i5.DefinitionForWrite? definitionForWrite) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateDefinition,
          [definitionForWrite],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateWordChangedDefinition(
    String? previousWordId,
    String? newWordId,
    _i5.DefinitionForWrite? definitionForWrite,
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updateDefinitionAndCreateWord(
    _i5.DefinitionForWrite? definitionForWrite,
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> deleteDefinition(
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> updatePostType({
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> likeDefinition(
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> unlikeDefinition(
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
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<bool> isLikedByUser(
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
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
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
