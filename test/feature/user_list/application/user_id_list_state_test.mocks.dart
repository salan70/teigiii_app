// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/user_list/application/user_id_list_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i7;
import 'package:teigi_app/feature/user_list/domain/user_id_list_state.dart'
    as _i3;
import 'package:teigi_app/feature/user_list/repository/fetch_user_list_repository.dart'
    as _i4;

import 'user_id_list_state_test.dart' as _i6;

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

class _FakeUserIdListState_1 extends _i1.SmartFake
    implements _i3.UserIdListState {
  _FakeUserIdListState_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FetchUserListRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockFetchUserListRepository extends _i1.Mock
    implements _i4.FetchUserListRepository {
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
  _i5.Future<_i3.UserIdListState> fetchFollowingIdList(
    String? userId,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchFollowingIdList,
          [
            userId,
            lastDocument,
          ],
        ),
        returnValue:
            _i5.Future<_i3.UserIdListState>.value(_FakeUserIdListState_1(
          this,
          Invocation.method(
            #fetchFollowingIdList,
            [
              userId,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.UserIdListState>.value(_FakeUserIdListState_1(
          this,
          Invocation.method(
            #fetchFollowingIdList,
            [
              userId,
              lastDocument,
            ],
          ),
        )),
      ) as _i5.Future<_i3.UserIdListState>);

  @override
  _i5.Future<_i3.UserIdListState> fetchFollowerIdList(
    String? userId,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchFollowerIdList,
          [
            userId,
            lastDocument,
          ],
        ),
        returnValue:
            _i5.Future<_i3.UserIdListState>.value(_FakeUserIdListState_1(
          this,
          Invocation.method(
            #fetchFollowerIdList,
            [
              userId,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.UserIdListState>.value(_FakeUserIdListState_1(
          this,
          Invocation.method(
            #fetchFollowerIdList,
            [
              userId,
              lastDocument,
            ],
          ),
        )),
      ) as _i5.Future<_i3.UserIdListState>);

  @override
  _i5.Future<_i3.UserIdListState> fetchLikedUserIdList(
    String? definitionId,
    _i2.QueryDocumentSnapshot<Object?>? lastDocument,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchLikedUserIdList,
          [
            definitionId,
            lastDocument,
          ],
        ),
        returnValue:
            _i5.Future<_i3.UserIdListState>.value(_FakeUserIdListState_1(
          this,
          Invocation.method(
            #fetchLikedUserIdList,
            [
              definitionId,
              lastDocument,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.UserIdListState>.value(_FakeUserIdListState_1(
          this,
          Invocation.method(
            #fetchLikedUserIdList,
            [
              definitionId,
              lastDocument,
            ],
          ),
        )),
      ) as _i5.Future<_i3.UserIdListState>);
}

/// A class which mocks [Listener].
///
/// See the documentation for Mockito's code generation for more information.
class MockListener extends _i1.Mock
    implements _i6.Listener<_i7.AsyncValue<_i3.UserIdListState>> {
  @override
  void call(
    _i7.AsyncValue<_i3.UserIdListState>? previous,
    _i7.AsyncValue<_i3.UserIdListState>? next,
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
