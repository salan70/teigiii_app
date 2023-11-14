import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../util/constant/default_value.dart';
import '../../../../util/constant/firestore_collections.dart';
import '../../domain/user_profile.dart';

part 'user_profile_document.freezed.dart';

@freezed
class UserProfileDocument with _$UserProfileDocument {
  const factory UserProfileDocument({
    required String id,
    required String publicId,
    required String name,
    required String bio,
    required String profileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileDocument;
  const UserProfileDocument._();

  factory UserProfileDocument.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserProfileDocument(
      id: doc.id,
      publicId: data[UserProfilesCollection.publicId] as String,
      name: data[UserProfilesCollection.name] as String,
      bio: data[UserProfilesCollection.bio] as String,
      profileImageUrl:
          data[UserProfilesCollection.profileImageUrl] as String? ??
              defaultImageUrl,
      createdAt: (data[createdAtFieldName] as Timestamp).toDate(),
      updatedAt: (data[updatedAtFieldName] as Timestamp).toDate(),
    );
  }

  UserProfile toUserProfile() {
    return UserProfile(
      id: id,
      publicId: publicId,
      name: name,
      bio: bio,
      profileImageUrl: profileImageUrl,
      croppedFile: null,
    );
  }
}
