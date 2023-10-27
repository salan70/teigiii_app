// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/user_config/user_config_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:teigi_app/feature/user_config/repository/entity/user_config_document.dart'
    as _i3;
import 'package:teigi_app/feature/user_config/repository/package_info_repository.dart'
    as _i6;
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart'
    as _i4;

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

class _FakeUserConfigDocument_1 extends _i1.SmartFake
    implements _i3.UserConfigDocument {
  _FakeUserConfigDocument_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserConfigRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserConfigRepository extends _i1.Mock
    implements _i4.UserConfigRepository {
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
  _i5.Future<_i3.UserConfigDocument> fetchUserConfig(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserConfig,
          [userId],
        ),
        returnValue:
            _i5.Future<_i3.UserConfigDocument>.value(_FakeUserConfigDocument_1(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.UserConfigDocument>.value(_FakeUserConfigDocument_1(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
      ) as _i5.Future<_i3.UserConfigDocument>);

  @override
  _i5.Future<void> addUserConfig(
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> updateVersionInfo(
    String? userId,
    String? osVersion,
    String? appVersion,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateVersionInfo,
          [
            userId,
            osVersion,
            appVersion,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> appendMutedUserIdList(
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> removeMutedUserIdList(
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
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [PackageInfoRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPackageInfoRepository extends _i1.Mock
    implements _i6.PackageInfoRepository {
  @override
  _i5.Future<String> fetchAppVersion() => (super.noSuchMethod(
        Invocation.method(
          #fetchAppVersion,
          [],
        ),
        returnValue: _i5.Future<String>.value(''),
        returnValueForMissingStub: _i5.Future<String>.value(''),
      ) as _i5.Future<String>);
}