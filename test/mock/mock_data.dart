import 'package:teigi_app/feature/definition/repository/entity/definition_document.dart';
import 'package:teigi_app/feature/user/repository/entity/user_document.dart';
import 'package:teigi_app/feature/word/repository/entity/word_document.dart';

final nowDateTime = DateTime.now();

final mockDefinitionDocumentList = [
  DefinitionDocument(
    id: 'definitionId',
    wordId: mockWordDocument.id,
    authorId: mockUserDocument.id,
    content: 'content',
    likesCount: 0,
    isPublic: true,
    createdAt: nowDateTime,
    updatedAt: nowDateTime,
  ),
];

final mockUserDocument = UserDocument(
  id: 'userId',
  name: 'name',
  email: 'email',
  profileImageUrl: 'profileImageUrl',
  mutedUserIdList: ['mutedUserId'],
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);

final mockWordDocument = WordDocument(
  id: 'wordId',
  word: 'word',
  reading: 'reading',
  initialLetter: 'i',
  createdAt: nowDateTime,
  updatedAt: nowDateTime,
);
