// Mocks generated by Mockito 5.4.2 from annotations
// in teigi_app/test/feature/auth/application/auth_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:firebase_auth/firebase_auth.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:riverpod_annotation/riverpod_annotation.dart' as _i13;
import 'package:teigi_app/feature/auth/repository/auth_repository.dart' as _i11;
import 'package:teigi_app/feature/user/repository/entity/user_profile_document.dart'
    as _i3;
import 'package:teigi_app/feature/user/repository/user_profile_repository.dart'
    as _i6;
import 'package:teigi_app/feature/user_config/repository/device_info_repository.dart'
    as _i9;
import 'package:teigi_app/feature/user_config/repository/entity/user_config_document.dart'
    as _i4;
import 'package:teigi_app/feature/user_config/repository/package_info_repository.dart'
    as _i10;
import 'package:teigi_app/feature/user_config/repository/user_config_repository.dart'
    as _i8;

import 'auth_service_test.dart' as _i12;

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

class _FakeUserProfileDocument_1 extends _i1.SmartFake
    implements _i3.UserProfileDocument {
  _FakeUserProfileDocument_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUserConfigDocument_2 extends _i1.SmartFake
    implements _i4.UserConfigDocument {
  _FakeUserConfigDocument_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFirebaseAuth_3 extends _i1.SmartFake implements _i5.FirebaseAuth {
  _FakeFirebaseAuth_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [UserProfileRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserProfileRepository extends _i1.Mock
    implements _i6.UserProfileRepository {
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
  _i7.Future<_i3.UserProfileDocument> fetchUserProfile(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserProfile,
          [userId],
        ),
        returnValue: _i7.Future<_i3.UserProfileDocument>.value(
            _FakeUserProfileDocument_1(
          this,
          Invocation.method(
            #fetchUserProfile,
            [userId],
          ),
        )),
        returnValueForMissingStub: _i7.Future<_i3.UserProfileDocument>.value(
            _FakeUserProfileDocument_1(
          this,
          Invocation.method(
            #fetchUserProfile,
            [userId],
          ),
        )),
      ) as _i7.Future<_i3.UserProfileDocument>);

  @override
  _i7.Future<void> addUserProfile(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

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

/// A class which mocks [UserConfigRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserConfigRepository extends _i1.Mock
    implements _i8.UserConfigRepository {
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
  _i7.Future<_i4.UserConfigDocument> fetchUserConfig(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUserConfig,
          [userId],
        ),
        returnValue:
            _i7.Future<_i4.UserConfigDocument>.value(_FakeUserConfigDocument_2(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
        returnValueForMissingStub:
            _i7.Future<_i4.UserConfigDocument>.value(_FakeUserConfigDocument_2(
          this,
          Invocation.method(
            #fetchUserConfig,
            [userId],
          ),
        )),
      ) as _i7.Future<_i4.UserConfigDocument>);

  @override
  _i7.Future<void> addUserConfig(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> updateUserConfig(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
}

/// A class which mocks [DeviceInfoRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceInfoRepository extends _i1.Mock
    implements _i9.DeviceInfoRepository {
  @override
  _i7.Future<String?> fetchOsVersion() => (super.noSuchMethod(
        Invocation.method(
          #fetchOsVersion,
          [],
        ),
        returnValue: _i7.Future<String?>.value(),
        returnValueForMissingStub: _i7.Future<String?>.value(),
      ) as _i7.Future<String?>);
}

/// A class which mocks [PackageInfoRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockPackageInfoRepository extends _i1.Mock
    implements _i10.PackageInfoRepository {
  @override
  _i7.Future<String> fetchAppVersion() => (super.noSuchMethod(
        Invocation.method(
          #fetchAppVersion,
          [],
        ),
        returnValue: _i7.Future<String>.value(''),
        returnValueForMissingStub: _i7.Future<String>.value(''),
      ) as _i7.Future<String>);
}

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i11.AuthRepository {
  @override
  _i5.FirebaseAuth get firebaseAuth => (super.noSuchMethod(
        Invocation.getter(#firebaseAuth),
        returnValue: _FakeFirebaseAuth_3(
          this,
          Invocation.getter(#firebaseAuth),
        ),
        returnValueForMissingStub: _FakeFirebaseAuth_3(
          this,
          Invocation.getter(#firebaseAuth),
        ),
      ) as _i5.FirebaseAuth);

  @override
  _i7.Stream<_i5.User?> get userChanges => (super.noSuchMethod(
        Invocation.getter(#userChanges),
        returnValue: _i7.Stream<_i5.User?>.empty(),
        returnValueForMissingStub: _i7.Stream<_i5.User?>.empty(),
      ) as _i7.Stream<_i5.User?>);

  @override
  _i7.Future<void> signInAnonymously() => (super.noSuchMethod(
        Invocation.method(
          #signInAnonymously,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);
}

/// A class which mocks [Listener].
///
/// See the documentation for Mockito's code generation for more information.
class MockListener extends _i1.Mock
    implements _i12.Listener<_i13.AsyncValue<void>> {
  @override
  void call(
    _i13.AsyncValue<void>? previous,
    _i13.AsyncValue<void>? next,
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
